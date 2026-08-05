variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "kestra-sandbox-498004"
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
  default     = "nik-rba-asx-data-lake"
}
