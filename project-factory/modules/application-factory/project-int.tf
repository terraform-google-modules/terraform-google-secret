/*************************************************************************************
  Integration Project
 ************************************************************************************/
locals {
  group_name_int = "${local.is_group_owner ? var.project_group_owner : "gcp-auto-apps-${var.application_name}-int"}"
}

module "project-application-int" {
  source  = "../../"
  name    = "${var.application_name}-int"
  enabled = "${local.environments["int"] ? "true" : "false"}"

  org_id    = "${local.organization_id}"
  folder_id = "${local.folder_int}"

  usage_bucket_name = "${local.usage_bucket_int}"
  billing_account   = "${local.billing_account}"

  create_group = "${local.is_group_owner ? false : true}"
  group_role   = "roles/editor"
  group_name   = "${local.group_name_int}"

  activate_apis = "${var.activate_apis}"

  shared_vpc         = "${local.xpn_int}"
  shared_vpc_subnets = "${local.subnets_int}"

  sa_group         = "${local.sa_group}"
  api_sa_group     = "${local.api_sa_group}"
  credentials_path = "${var.credentials_path}"
}

resource "gsuite_group_member" "int_group_owner" {
  count = "${!local.is_group_owner && local.environments["int"] ? 1 : 0}"
  group = "${module.project-application-int.group_email}"
  email = "${var.project_group_owner}"
  role  = "OWNER"
}
