locals {
  credentials_file_path = "${var.credentials_file_path}"
}

/******************************************
  Provider configuration
 *****************************************/
provider "google" {
  credentials = "${file(local.credentials_file_path)}"
}

module "project-factory" {
  source            = "../../"
  random_project_id = "${var.random_project_id}"
  name              = "${var.name}"
  org_id            = "${var.org_id}"
  usage_bucket_name = "${var.usage_bucket_name}"
  billing_account   = "${var.billing_account}"
  group_role        = "${var.group_role}"
  credentials_path  = "${local.credentials_file_path}"
}
