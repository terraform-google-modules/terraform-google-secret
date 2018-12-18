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

variable organization_id {}

variable "name_prod_gke" {}

variable "org_id_prod_gke" {}

variable "billing_account_prod_gke" {}

variable "group_role_prod_gke" {}

variable "folder_id_prod_gke" {}

variable "labels_prod_gke" {
  description = "Map of labels for project"
  type        = "map"
  default     = {}
}

variable "name_factory" {}

variable "org_id_factory" {}

variable "usage_bucket_name_factory" {}

variable "billing_account_factory" {}

variable "group_role_factory" {}

variable "shared_vpc_factory" {}

variable "sa_group_factory" {}

variable "folder_id_factory" {}
