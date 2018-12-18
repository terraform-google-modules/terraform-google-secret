locals {
  credentials_file_path = "${var.credentials_file_path}"
}

/******************************************
  Provider configuration
 *****************************************/
provider "google" {
  credentials = "${file(local.credentials_file_path)}"
}

provider "gsuite" {
  credentials             = "${file(local.credentials_file_path)}"
  impersonated_user_email = "${var.impersonated_user_email}"

  oauth_scopes = "${var.oauth_scopes}"
}

module "project-factory" {
  source             = "../../"
  random_project_id  = "${var.random_project_id}"
  name               = "${var.name}"
  org_id             = "${var.org_id}"
  usage_bucket_name  = "${var.usage_bucket_name}"
  billing_account    = "${var.billing_account}"
  group_role         = "${var.group_role}"
  shared_vpc         = "${var.shared_vpc}"
  sa_group           = "${var.sa_group}"
  folder_id          = "${var.folder_id}"
  credentials_path   = "${local.credentials_file_path}"
  create_group       = "${var.create_group}"
  group_name         = "${var.group_name}"
  shared_vpc_subnets = "${var.shared_vpc_subnets}"
  labels             = "${var.labels}"
  api_sa_group       = "${var.api_sa_group}"
  bucket_project     = "${var.bucket_project}"
  bucket_name        = "${var.bucket_name}"
}
