/*
If we don't need to work with gsuite, we can use the project-factory without install/configure gsuite,
only is necessary delete this file that contains the gsuite resources.
*/

/******************************************
  Group email construction when group already exists
 *****************************************/
data "null_data_source" "data_given_group_email" {
  inputs {
    given_group_email = "${var.create_group == "false" ? format("%s@%s", var.group_name, local.domain) : ""}"
  }
}

/******************************************
  Group email to be used on resources
 *****************************************/
data "null_data_source" "data_final_group_email" {
  inputs {
    final_group_email = "${var.create_group == "true" ? element(coalescelist(gsuite_group.group.*.email, list("")), 0) : data.null_data_source.data_given_group_email.outputs["given_group_email"]}"
  }
}

/***********************************************
  Make service account member of sa_group group
 ***********************************************/
resource "gsuite_group_member" "service_account_sa_group_member" {
  count = "${(local.enabled) ? 1 : 0}"

  group = "${var.sa_group}"
  email = "${google_service_account.default_service_account.email}"
  role  = "MEMBER"

  depends_on = ["google_service_account.default_service_account"]
}

/******************************************
  Gsuite Group Configuration
 *****************************************/
resource "gsuite_group" "group" {
  count = "${(local.enabled && var.create_group) ? 1 : 0}"

  email       = "${var.group_name != "" ? format("%s@%s", var.group_name, local.domain) : format("%s-editors@%s", var.name, local.domain)}"
  name        = "${var.group_name != "" ? var.group_name : format("%s-editors",var.name)}"
  description = "${var.name} project group"
}

/***********************************************
  Make APIs service account member of api_sa_group
 ***********************************************/
resource "gsuite_group_member" "api_s_account_api_sa_group_member" {
  count = "${(local.enabled && var.api_sa_group != "") ? 1 : 0}"

  group = "${var.api_sa_group}"
  email = "${local.api_s_account}"
  role  = "MEMBER"

  depends_on = ["google_project_service.project_services"]
}
