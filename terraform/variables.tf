variable "project_id" {
  description = "GCP project ID"
  type        = string

  validation {
    condition     = var.project_id != "your-gcp-project-id"
    error_message = "Set project_id in terraform.tfvars to your own GCP project ID (it is still the placeholder)."
  }
}

variable "region" {
  description = "GCP region for the bucket"
  type        = string
  default     = "australia-southeast1"
}

variable "bq_location" {
  description = "BigQuery dataset location"
  type        = string
  default     = "australia-southeast1"
}

variable "bucket_name" {
  description = "Globally-unique GCS bucket name for the raw data lake"
  type        = string

  validation {
    condition     = var.bucket_name != "your-unique-bucket-name"
    error_message = "Set bucket_name in terraform.tfvars to your own bucket (it is still the placeholder)."
  }
}
