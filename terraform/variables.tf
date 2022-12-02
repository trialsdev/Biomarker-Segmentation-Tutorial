variable "billing_account_name" {
    default = "" #enter billing account name here
}

variable "user" {
    default = "" #enter user email address here
}

locals {
    project_name = "segtutorial${random_id.id.hex}" #enter your project name
    project = "${local.project_name}"
    region = "us-east1"

    input_bucket = "bst_input_bucket" #enter your input bucket name
    output_bucket = "bst_output_bucket" #enter your output bucket name
    data_bucket = "bst_data_bucket" #enter your data bucket name

    container_image_name = "bst-image" #enter your container image name
    image_name = "grc.io/${local.project}/${local.container_image_name}"
    image_tag = "latest"
    image_uri = "${local.image_name}:${local.image_tag}"

}

variable "gcp_service_list" {

  description ="The list of apis necessary for the project"
  type = list(string)
  default = [
    "compute.googleapis.com",
    "containerregistry.googleapis.com",
    "run.googleapis.com"  
  ]
}

resource "random_id" "id" {
    byte_length = 4
}

