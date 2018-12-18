variable "credentials_file_path" {
  description = "Service account json auth path"
}

variable "gsuite_admin_user" {
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
