import tensorflow as tf
from models.vnet import VNet
import os
import ants
import fsl
import nibabel as nib
from preprocess import convert, extract, register
from google.cloud import storage
import tempfile

#weights path
# weights_path = os.path.join('weights', 'weights.index')
weights_path = os.path.join('weights.index')
template_path = os.path.join('templates', 'scct_unsmooth_SS_0.01_128x128x128.nii.gz')

#cloud storage client
storage_client = storage.Client()

def run_inference(data):

    #load model
    model = VNet()
    model.load_weights(weights_path)

    #load template
    template = ants.image_read(template_path, pixeltype = 'float')

    #get recieved file
    image, file_name = receive_data(data)
    print('Downloaded file from input bucket')

    #load image
    image = nib.load(image)
    original_header = image.header
    original_affine = image.affine
    original_image = convert.nii2ants(image)

    #extract brain
    image = extract.brain(image)
    image = convert.nii2ants(image)
    image, transforms = register.rigid(template, image)
    image, ants_params = convert.ants2np(image)

    #predict
    prediction = model.predict(image)
    prediction = convert.np2ants(prediction, ants_params)

    #invert registration
    prediction = register.invert(original_image, prediction, transforms)
    prediction = nib.Nifti1Image(prediction.numpy(), header = original_header, affine = original_affine)
    print('Made the prediction using the DL model')

    #save image locally
    nib.save(prediction, "output_nifti.nii.gz")
    
    #upload data to the output bucket
    upload_data(file_name)
    print('Uploaded file')

def receive_data(data):

    file_data = data
    file_name = file_data["name"]
    bucket_name = file_data["bucket"]
    input_bucket = storage_client.get_bucket(bucket_name)
    input_blob = input_bucket.get_blob(file_name)

    with open("input_nifti.nii.gz", "wb") as image_file:
        image_file.write(input_blob.download_as_bytes())

    return "input_nifti.nii.gz", file_name

def upload_data(file_name):

    #output bucket name
    bucket_name = "bst_output_bucket" #use the name of the correct output bucket
    output_bucket = storage_client.get_bucket(bucket_name)
    #output file name
    output_file_name = f"{file_name.split('.')[0]}_predict.nii.gz"
    output_blob = output_bucket.blob(output_file_name)

    with open("output_nifti.nii.gz", "rb") as output_file:
        output_blob.upload_from_file(output_file)
    
