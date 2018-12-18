/*************************************************************************************
  Development Project
 ************************************************************************************/
locals {
  group_name_dev = "${local.is_group_owner ? var.project_group_owner : "gcp-auto-apps-${var.application_name}-dev"}"
}

module "project-application-dev" {
  source  = "../../"
  name    = "${var.application_name}-dev"
  enabled = "${local.environments["dev"] ? "true" : "false"}"

  org_id    = "${local.organization_id}"
  folder_id = "${local.folder_dev}"

  usage_bucket_name = "${local.usage_bucket_dev}"
  billing_account   = "${local.billing_account}"

  create_group = "${local.is_group_owner ? false : true}"
  group_role   = "roles/editor"
  group_name   = "${local.group_name_dev}"

  activate_apis = "${var.activate_apis}"

  shared_vpc         = "${local.xpn_dev}"
  shared_vpc_subnets = "${local.subnets_dev}"

  sa_group         = "${local.sa_group}"
  api_sa_group     = "${local.api_sa_group}"
  credentials_path = "${var.credentials_path}"
}

resource "gsuite_group_member" "dev_group_owner" {
  count = "${!local.is_group_owner && local.environments["dev"] ? 1 : 0}"
  group = "${module.project-application-dev.group_email}"
  email = "${var.project_group_owner}"
  role  = "OWNER"
}

# Also give developers IAM admin in dev project
resource "google_project_iam_member" "dev_group_iam_admin" {
  count   = "${local.environments["dev"] ? 1 : 0}"
  project = "${module.project-application-dev.project_id}"
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "group:${local.group_name_dev}@example.com"
}

# Give them IAM role admin for creating custom roles
resource "google_project_iam_member" "dev_group_role_admin" {
  count   = "${local.environments["dev"] ? 1 : 0}"
  project = "${module.project-application-dev.project_id}"
  role    = "roles/iam.roleAdmin"
  member  = "group:${local.group_name_dev}@example.com"
}
