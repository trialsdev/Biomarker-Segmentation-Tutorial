# Biomarker Segmentation Cloud Migration Code #

This repository contains code that helps you to create a medical image segmentation workflow in the Google Cloud Platform (GCP). The model we are using in this example is the <a href = "https://github.com/msharrock/deepbleed">Deepbleed</a> model which is used for Intracerebral Hemorrhage (ICH) Segmentation. The code creates the following infrastructure in GCP. 

<img src = "https://user-images.githubusercontent.com/85404022/205371247-a677c4c3-1596-4b09-aebd-aa176703d24c.png" width = 750, height = 500></img>

The GCP infrastructure expects input patient images in <a href = "https://nifti.nimh.nih.gov/">NIfTI</a> file format and outputs the segmented masks as a NIfTI file.

*Please note that in order to minimize the resources used in GCP, we are not using any GPU resources. If you'd like to learn how to create a docker image with GPU resources enabled, please visit the <a href = "https://github.com/msharrock/deepbleed">Deepbleed</a> model page for more information.*

## Billable Resources ##

The following billable resources from GCP will be used in this example.

1. <a href = "https://cloud.google.com/run">Google Cloud Run</a>
2. <a href = "https://cloud.google.com/storage">Google Cloud Storage</a>
3. <a href = "https://cloud.google.com/pubsub">Pub/Sub</a>
4. <a href = "https://cloud.google.com/container-registry">Google Cloud Container Registry</a>

## Setup & Requirements ##

In order to run the code you will need a Google Cloud Platform Account with a billing account. You will also need terraform and docker installed in your local machine. The following are resources on how to setup a GCP account and how to install terraform & docker locally.

1. <a href = "https://cloud.google.com/sdk/docs/install">Google Cloud CLI </a>

2. <a href = "https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli"> Terraform </a>

3. <a href = "https://docs.docker.com/get-docker/"> Docker </a>

## Add credentials ##

Before running the code, first you need to edit the var.tf file with your credentials. You can locate this file in the terraform folder and edit the billing account name and the user email address.

```
variable "billing_account_name" {
    default = "your billing account name"
}

variable "user" {
    default = "your GCP email address"
}
```

## Run Code ##

```
github clone https://github.com/trialsdev/Biomarker-Segmentation-Tutorial.git 
cd terraform
terraform init
terraform plan
terraform apply
```

## Test Code ##

In order to test the code, move the data in the "data_bucket" to the "input_bucket" to invoke the cloud run app. The resulting files will be saved in the "output_bucket". The following commands will help you move the files from the "data_bucket" to the "input_bucket". *Note that you can manually upload an object to the "input_bucket" as well.*

GCP Shell
  
```
gsutil cp gs://bs_data_bucket/test.nii.gz gs://bs_input_bucket/test.nii.gz
```
GCP CLI
  
```
gcloud storage cp gs://bs_data_bucket/test.nii.gz gs://bs_input_bucket/test.nii.gz
```
  
## Destroy the infrastructure ##

```
terraform destroy
```

## Additional Information ##

- While destroying the infrastructure, if you recieve an error that says a certain "API is disabled", please go to GCP platform by clicking the corresponding link. Then enable the API and run terraform destroy again in your local machine.

## References & Useful Links ##
  
- <a href = "https://cloud.google.com/docs/terraform/get-started-with-terraform"> Google Cloud - Terraform documentation </a>
- <a href = "https://registry.terraform.io/providers/hashicorp/google/latest/docs"> Terraform - Google Cloud documentation </a>
- <a href = "https://cloud.google.com/pubsub/docs/tutorials"> Google Cloud Pub/Sub tutorials </a>
- <a href = "https://codelabs.developers.google.com/codelabs/cloud-run-hello-python3#6"> Google Cloud Run tutorials </a>
