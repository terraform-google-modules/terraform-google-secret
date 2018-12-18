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

resource "google_folder" "prod" {
  display_name = "gcp-prod"
  parent       = "organizations/${var.organization_id}"
}

module "project-prod-gke" {
  source           = "../../"
  name             = "${var.name_prod_gke}"
  org_id           = "${var.org_id_prod_gke}"
  billing_account  = "${var.billing_account_prod_gke}"
  group_role       = "${var.group_role_prod_gke}"
  credentials_path = "${local.credentials_file_path}"

  folder_id = "${var.folder_id_prod_gke}"
  labels    = "${var.labels_prod_gke}"
}

module "project-factory" factory {
  source            = "../../"
  name              = "${var.name_factory}"
  org_id            = "${var.org_id_factory}"
  usage_bucket_name = "${var.usage_bucket_name_factory}"
  billing_account   = "${var.billing_account_factory}"
  group_role        = "${var.group_role_factory}"
  shared_vpc        = "${var.shared_vpc_factory}"
  sa_group          = "${var.sa_group_factory}"
  folder_id         = "${var.folder_id_factory}"
  credentials_path  = "${local.credentials_file_path}"
}
