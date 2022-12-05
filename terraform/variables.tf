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

    input_bucket = "bst_input_bucket_${random_id.id.hex}" #enter your input bucket name
    output_bucket = "bst_output_bucket_${random_id.id.hex}" #enter your output bucket name
    data_bucket = "bst_data_bucket_${random_id.id.hex}" #enter your data bucket name

    container_image_name = "bst-image" #enter your container image name
    image_name = "gcr.io/${local.project}/${local.container_image_name}"
    image_tag = "latest"
    image_uri = "${local.image_name}:${local.image_tag}"

}


resource "random_id" "id" {
    byte_length = 2
}

