provider "google" {
    project = local.project
    region = local.region
}

data "google_billing_account" "account" {
    #this needs to be the literal name of the billing account. Change the billing account name in the variables.tf file
    display_name = var.billing_account_name
}

resource "google_project" "project" {
    name = local.project_name
    project_id = local.project
    billing_account = data.google_billing_account.account.id
}

resource "google_project_iam_member" "project_owner" {
    role = "roles/owner"
    member = "user:${var.user}"
    project = local.project_name

    depends_on = [
        google_project.project
    ]
}

resource "google_storage_bucket" "storage_input_bucket" {
    name = local.input_bucket
    location = "US"
    force_destroy = true
    
    depends_on = [
        google_project_iam_member.project_owner
    ]
}

resource "google_storage_bucket" "storage_output_bucket" {
    name = local.output_bucket
    location = "US"
    force_destroy = true

    depends_on = [
        google_project_iam_member.project_owner
    ]
}

resource "google_storage_bucket" "storage_data_bucket" {
    name = local.data_bucket
    location = "US"
    force_destroy = true

    depends_on = [
        google_project_iam_member.project_owner
    ]
}


resource "google_project_service" "cloud_registry_service" {
  service = "containerregistry.googleapis.com"
  disable_dependent_services = true

  depends_on = [
    google_project.project,
  ]
}

resource "google_project_service" "cloud_build_service" {
  service = "cloudbuild.googleapis.com"
  disable_dependent_services = true

  depends_on = [
    google_project.project,
  ]
}

resource "google_project_service" "cloud_run_service" {
  service = "run.googleapis.com"
  disable_dependent_services = true

  depends_on = [
    google_project.project,
  ]
}

#create cloud run service using the image
resource "google_cloud_run_service" "default" {
  
  project = local.project_name
  name     = "bst-cloudrun" #name the cloud run service
  location = local.region

  template {
    spec {
      containers {
        image = local.image_uri # Replace with newly created image gcr.io/<project_id>/pubsub
        resources {
          limits = {
            cpu = "2.0"
            memory = "8000Mi"
          }
        }
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
  depends_on = [
    google_project.project,
    google_project_service.cloud_run_service,
    null_resource.app_container, 
  ]
}

#create an the image from app directory.
resource "null_resource" "app_container" {

    provisioner "local-exec" {
        command = "(cd ../dummy_app && ./build.sh && IMAGE_URI=${local.image_uri} ./push.sh)"
        #command = "docker build -t ${local.image_uri} ../dummy_app/ && docker push ${local.image_uri}"
    }
    depends_on = [
        google_project.project
    ]
}


#create the pubsub notification system.

resource "google_pubsub_topic" "default" {
    name = "bst-pubsub-topic"
}
    