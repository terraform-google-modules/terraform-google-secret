/*************************************************************************************
  Production Project
 ************************************************************************************/
locals {
  group_name_prod = "${local.is_group_owner ? var.project_group_owner : "gcp-auto-apps-${var.application_name}-prod"}"
}

module "project-application-prod" {
  source  = "../../"
  name    = "${var.application_name}-prod"
  enabled = "${local.environments["prod"] ? "true" : "false"}"

  org_id    = "${local.organization_id}"
  folder_id = "${local.folder_prod}"

  usage_bucket_name = "${local.usage_bucket_prod}"
  billing_account   = "${local.billing_account}"

  create_group = "${local.is_group_owner ? false : true}"
  group_role   = "roles/editor"
  group_name   = "${local.group_name_prod}"

  activate_apis = "${var.activate_apis}"

  shared_vpc         = "${local.xpn_prod}"
  shared_vpc_subnets = "${local.subnets_prod}"

  sa_group         = "${local.sa_group}"
  api_sa_group     = "${local.api_sa_group}"
  credentials_path = "${var.credentials_path}"
}

resource "gsuite_group_member" "prod_group_owner" {
  count = "${!local.is_group_owner && local.environments["prod"] ? 1 : 0}"

  group = "${module.project-application-prod.group_email}"
  email = "${var.project_group_owner}"
  role  = "OWNER"
}
