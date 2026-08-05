terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Raw data lake bucket
resource "google_storage_bucket" "data_lake" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  lifecycle_rule {
    condition { age = 90 }
    action { type = "Delete" }
  }
}

# BigQuery dataset for raw loaded data
resource "google_bigquery_dataset" "raw" {
  dataset_id = "rba_asx_raw"
  location   = var.bq_location
}

# BigQuery dataset for dbt models (staging + core)
resource "google_bigquery_dataset" "analytics" {
  dataset_id = "rba_asx_analytics"
  location   = var.bq_location
}
