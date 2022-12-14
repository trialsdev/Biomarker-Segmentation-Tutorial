variable "billing_account_name" {
    default = "" #enter billing account name here
}

variable "user" {
    default = "" #enter user email address here
}

locals {

    project_name = "biosegtutorial${random_id.id.hex}" #enter your project name
    project = "${local.project_name}"
    region = "us-east1"

    input_bucket = "bs_input_bucket" #enter your input bucket name
    output_bucket = "bs_output_bucket" #enter your output bucket name
    data_bucket = "bs_data_bucket" #enter your data bucket name

    container_image_name = "bst-image" #enter your container image name
    image_name = "gcr.io/${local.project}/${local.container_image_name}"
    image_tag = "latest"
    image_uri = "${local.image_name}:${local.image_tag}"

}


resource "random_id" "id" {
    byte_length = 2
}

