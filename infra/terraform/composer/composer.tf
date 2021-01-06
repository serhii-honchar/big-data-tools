resource "google_composer_environment" "bigdata_tools_env" {
  provider = google-beta

  name   = "bigdata-tools-env"
  region = var.region
  labels = {
    bigdata-tools = true
  }

  config {
    node_count = 3

    node_config {
      zone         = var.zone
      machine_type = "n1-standard-1"
      disk_size_gb = 50
    }

    software_config {
      image_version  = var.composer_image_version
      python_version = 3

      airflow_config_overrides = {
        core-load_example = "True"
      }
    }
  }
}