/*************************************************************************************
  Sandbox Projects
 ************************************************************************************/
locals {
  is_group_owner = "${var.group_owner == "true" ? true : false}"
  gen_group_name = "${local.group_prefix}sandbox-${var.owner}"
  group_name     = "${local.is_group_owner ? var.owner : local.gen_group_name}"
}

module "project" {
  source            = "../.."
  name              = "${var.owner}-sbx"
  org_id            = "${local.organization_id}"
  folder_id         = "${local.folder_dev}"
  usage_bucket_name = "${local.usage_bucket_dev}"
  billing_account   = "${local.billing_account}"

  create_group = "${local.is_group_owner ? false : true}"
  group_role   = "roles/owner"
  group_name   = "${local.group_name}"

  shared_vpc = "${local.xpn_dev}"

  shared_vpc_subnets = "${concat(
    local.subnets_dev
  )}"

  sa_group         = "${local.sa_group}"
  api_sa_group     = "${local.api_sa_group}"
  credentials_path = "${var.credentials_path}"
}

resource "gsuite_group_member" "sandbox_owner" {
  count = "${local.is_group_owner ? 0 : 1}"
  group = "${module.project.group_email}"
  email = "${var.owner}@example.com"
  role  = "OWNER"
}
