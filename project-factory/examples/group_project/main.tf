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
  impersonated_user_email = "${var.gsuite_admin_user}"

  oauth_scopes = "${var.oauth_scopes}"
}

module "project-factory" {
  source            = "../../"
  random_project_id = "${var.random_project_id}"
  name              = "${var.name}"
  org_id            = "${var.org_id}"
  usage_bucket_name = "${var.usage_bucket_name}"
  billing_account   = "${var.billing_account}"
  credentials_path  = "${local.credentials_file_path}"

  # Create a group and give it the role
  create_group = "true"
  group_name   = "${var.name}-devs"
  group_role   = "${var.group_role}"
}
