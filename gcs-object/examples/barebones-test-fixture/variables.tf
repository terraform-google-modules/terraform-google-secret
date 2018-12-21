variable "credentials_file_path" {
  description = "path to creds"
}

variable "project_name" {
  description = "name of the GCP project to create resources within"
}

variable "environment" {
  description = "the environment in which we create the test resources"
  default     = "dev"
}

variable "region" {
  description = "Region in which we create resources"
  default     = "us-west1"
}
