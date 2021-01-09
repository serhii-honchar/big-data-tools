resource "random_id" "staging_bucket" {
  byte_length = 8
}

resource "google_storage_bucket" "dataproc_staging_bucket" {
  name = "dataproc-staging-bucket-${lower(random_id.staging_bucket.hex)}"
  labels = {
    bigdata-procamp = true
  }

  location      = var.region
  storage_class = "STANDARD"
  force_destroy = true
}

resource "google_dataproc_cluster" "procamp_cluster" {
  provider = google-beta

  name   = "bigdata-tools-cluster"
  region = var.region
  labels = {
    bigdata-tools = true
  }

  cluster_config {
    staging_bucket = google_storage_bucket.dataproc_staging_bucket.name

    master_config {
      num_instances = 1
      machine_type  = "n1-standard-4"
      disk_config {
        boot_disk_size_gb = 100
        num_local_ssds    = 0
      }
    }

    worker_config {
      num_instances = 2
      machine_type  = "n1-standard-1"
      disk_config {
        boot_disk_size_gb = 50
        num_local_ssds    = 0
      }
    }

    software_config {
      image_version = "1.5-ubuntu18"

      optional_components = [
        "ANACONDA",
        "ZEPPELIN",
        "ZOOKEEPER",
        "SOLR"
      ]
    }

    gce_cluster_config {
      zone = var.zone

      metadata = {
        "enable-oslogin" : true,
        "run-on-master" : true,
        "kafka-enable-jmx" : true
      }

      service_account_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
        "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
        "https://www.googleapis.com/auth/devstorage.read_write",
        "https://www.googleapis.com/auth/logging.write"
      ]
    }

    initialization_action {
      script      = "gs://goog-dataproc-initialization-actions-${var.region}/kafka/kafka.sh"
      timeout_sec = 600
    }

    initialization_action {
      script      = "gs://goog-dataproc-initialization-actions-${var.region}/oozie/oozie.sh"
      timeout_sec = 600
    }

    initialization_action {
      script      = "https://storage.googleapis.com/bigdata-tools/nifi/nifi.sh"
      timeout_sec = 600
    }

    initialization_action {
      script      = "https://storage.googleapis.com/bigdata-tools/sqoop/sqoop.sh"
      timeout_sec = 600
    }

    initialization_action {
      script      = "https://storage.googleapis.com/bigdata-tools/bigdata-tools/tools.sh"
      timeout_sec = 600
    }

    endpoint_config {
      enable_http_port_access = true
    }
  }
}