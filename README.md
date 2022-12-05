# Biomarker Segmentation Cloud Migration Code #

This repository contains code that helps you to create the following infrastructure in Google Cloud Platform.

![classification workflow](https://user-images.githubusercontent.com/85404022/205371247-a677c4c3-1596-4b09-aebd-aa176703d24c.png) 

## Setup & Requirements ##

In order to run the code you will need a Google Cloud Platform Account with a billing account.

The following tools are required to be installed in your local machine in order to run the code.

1. <a href = "https://cloud.google.com/sdk/docs/install">Google Cloud CLI </a>

2. <a href = "https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli"> Terraform </a>

## Run Code ##

```
github clone https://github.com/trialsdev/Biomarker-Segmentation-Tutorial.git 
cd terraform
terraform init
terraform plan
terraform apply
```

## Test Code ##

In order to test the code, you can move the data in the "data_bucket" to the "input_bucket" to invoke the cloud run app. The resulting files will be saved in the "output_bucket". Run the following command in the google cloud shell to move the file to the "input_bucket". (Note that you can manually upload an object to the "input_bucket" as well)

```
gsutil cp gs://input_bucket/test gs://input_bucket/test.nii.gz
```

## Destroy the infrastructure ##

```
terraform destroy
```
