/*************************************************************************************
  QE Project
 ************************************************************************************/
locals {
  group_name_qe = "${local.is_group_owner ? var.project_group_owner : "gcp-auto-apps-${var.application_name}-qe"}"
}

module "project-application-qe" {
  source  = "../../"
  name    = "${var.application_name}-qe"
  enabled = "${local.environments["qe"] ? "true" : "false"}"

  org_id    = "${local.organization_id}"
  folder_id = "${local.folder_qe}"

  usage_bucket_name = "${local.usage_bucket_qe}"
  billing_account   = "${local.billing_account}"

  create_group = "${local.is_group_owner ? false : true}"
  group_role   = "roles/editor"
  group_name   = "${local.group_name_qe}"

  activate_apis = "${var.activate_apis}"

  shared_vpc         = "${local.xpn_qe}"
  shared_vpc_subnets = "${local.subnets_qe}"

  sa_group         = "${local.sa_group}"
  api_sa_group     = "${local.api_sa_group}"
  credentials_path = "${var.credentials_path}"
}

resource "gsuite_group_member" "qe_group_owner" {
  count = "${!local.is_group_owner && local.environments["qe"] ? 1 : 0}"

  group = "${module.project-application-qe.group_email}"
  email = "${var.project_group_owner}"
  role  = "OWNER"
}
