provider "google" {
  region = var.region
}

provider "google-beta" {
  region = var.region
}

resource "random_id" "project_id" {
  byte_length = 4
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = "bigdata-tools-${lower(random_id.project_id.hex)}"
  billing_account = var.billing_account

  labels = {
    bigdata-tools = true
  }
}

resource "google_project_service" "project" {
  project = google_project.project.project_id

  for_each = toset([
    "dataproc.googleapis.com",
    "composer.googleapis.com",
  ])

  service = each.key

  disable_on_destroy = false
}

resource "random_id" "tf_state_bucket" {
  byte_length = 8
}

resource "google_storage_bucket" "tf_state_bucket" {
  name    = "tf-state-bucket-${lower(random_id.tf_state_bucket.hex)}"
  project = google_project.project.project_id

  labels = {
    bigdata-tools = true
  }

  versioning {
    enabled = true
  }

  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true
}

output "project_id" {
  value = google_project.project.project_id
}

output "tfstate_bucket" {
  value = google_storage_bucket.tf_state_bucket.name
}