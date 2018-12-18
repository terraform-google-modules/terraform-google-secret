variable "credentials_file_path" {
  description = "Service account json auth path"
}

variable "impersonated_user_email" {
  description = "Admin user on Gsuite"
}

variable "oauth_scopes" {
  description = "List of permissions on gsuite api"
  type        = "list"

  default = [
    "https://www.googleapis.com/auth/admin.directory.group",
    "https://www.googleapis.com/auth/admin.directory.group.member",
  ]
}

variable "random_project_id" {
  default = "true"
}

variable "name" {}

variable "org_id" {}

variable "usage_bucket_name" {}

variable "billing_account" {}

variable "group_role" {
  default = "roles/editor"
}

variable "shared_vpc" {}

variable "sa_group" {}

variable "folder_id" {}

variable "create_group" {}

variable "group_name" {}

variable "shared_vpc_subnets" {
  description = "List of host project's subnets to share with"
  type        = "list"
  default     = [""]
}

variable "labels" {
  description = "Map of labels for project"
  type        = "map"
  default     = {}
}

variable "api_sa_group" {
  default = ""
}

variable "bucket_project" {
  default = ""
}

variable "bucket_name" {
  default = ""
}
