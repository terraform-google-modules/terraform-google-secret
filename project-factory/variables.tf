variable "random_project_id" {
  description = "Enables project random id generation"
  default     = "false"
}

variable "org_id" {
  description = "The organization id for the associated services"
}

variable "name" {
  description = "The name for the project"
}

variable "enabled" {
  description = "Whether to create the project or not (default 'true')"
  default     = "true"
  type        = "string"
}

variable "shared_vpc" {
  description = "The ID of the host project which hosts the shared VPC"
  default     = ""
}

variable "billing_account" {
  description = "The ID of the billing account to associate this project with"
}

variable "folder_id" {
  description = "The ID of a folder to host this project"
  default     = ""
}

variable "group_name" {
  description = "A group to control the project by being assigned group_role - defaults to ${project_name}-editors"
  default     = ""
}

variable "create_group" {
  description = "Whether to create the group or not"
  default     = "false"
}

variable "group_role" {
  description = "The role to give the controlling group (group_name) over the project (defaults to project editor)"
  default     = "roles/editor"
}

variable "sa_group" {
  description = "A GSuite group to place the default Service Account for the project in"
  default     = ""
}

variable "sa_role" {
  description = "A role to give the default Service Account for the project (defaults to none)"
  default     = ""
}

variable "activate_apis" {
  description = "The list of apis to activate within the project"
  type        = "list"
  default     = ["compute.googleapis.com"]
}

variable "usage_bucket_name" {
  description = "Name of a GCS bucket to store GCE usage reports in (optional)"
  default     = ""
}

variable "credentials_path" {
  description = "Path to a Service Account credentials file with permissions documented in the readme"
}

variable "shared_vpc_subnets" {
  description = "List of subnets fully qualified subnet IDs (ie. projects/$project_id/regions/$region/subnetworks/$subnet_id)"
  type        = "list"
  default     = [""]
}

variable "labels" {
  description = "Map of labels for project"
  type        = "map"
  default     = {}
}

variable "bucket_project" {
  description = "A project to create a GCS bucket (bucket_name) in, useful for Terraform state (optional)"
  default     = ""
}

variable "bucket_name" {
  description = "A name for a GCS bucket to create (in the bucket_project project), useful for Terraform state (optional)"
  default     = ""
}

variable "api_sa_group" {
  description = "A GSuite group to place the Google APIs Service Account for the project in"
  default     = ""
}
