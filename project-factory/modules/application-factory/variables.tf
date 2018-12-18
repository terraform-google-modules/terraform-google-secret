variable "application_name" {
  description = "A unique name for the application, which will be used for all the application projects. Ex. gcp-fnd-locator"
}

variable "project_group_owner" {
  description = "The email of a user or group to be set as the initial owner of the project dev groups for this application"
}

variable "group_owner" {
  description = "Set to 'true' if this project is owned by a group (default 'false')"
  default     = "false"
  type        = "string"
}

variable "credentials_path" {
  description = "The path to a service account JSON key file with permission to create projects"
}

variable "environments" {
  description = "List of which environments to create projects for"
  type        = "list"
  default     = ["dev", "int", "st", "qe"]
}

variable "activate_apis" {
  description = "Overrides the default APIs to allow full control over what APIs are enabled. NOTE: this is an either/or option. If used, it will fully replace and destroy the old enabled APIs."

  default = [
    "compute.googleapis.com",
    "servicemanagement.googleapis.com",
    "storage-api.googleapis.com",
    "stackdriver.googleapis.com",
    "logging.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
  ]
}
