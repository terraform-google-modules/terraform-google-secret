/*************************************************************************************
  Staging Project
 ************************************************************************************/
locals {
  group_name_st = "${local.is_group_owner ? var.project_group_owner : "gcp-auto-apps-${var.application_name}-st"}"
}

module "project-application-st" {
  source  = "../../"
  name    = "${var.application_name}-st"
  enabled = "${local.environments["st"] ? "true" : "false"}"

  org_id    = "${local.organization_id}"
  folder_id = "${local.folder_st}"

  usage_bucket_name = "${local.usage_bucket_st}"
  billing_account   = "${local.billing_account}"

  create_group = "${local.is_group_owner ? false : true}"
  group_role   = "roles/editor"
  group_name   = "${local.group_name_st}"

  activate_apis = "${var.activate_apis}"

  shared_vpc         = "${local.xpn_st}"
  shared_vpc_subnets = "${local.subnets_st}"

  sa_group         = "${local.sa_group}"
  api_sa_group     = "${local.api_sa_group}"
  credentials_path = "${var.credentials_path}"
}

resource "gsuite_group_member" "st_group_owner" {
  count = "${!local.is_group_owner && local.environments["st"] ? 1 : 0}"

  group = "${module.project-application-st.group_email}"
  email = "${var.project_group_owner}"
  role  = "OWNER"
}
