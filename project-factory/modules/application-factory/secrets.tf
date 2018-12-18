/*************************************************************************************
  Application Secret Buckets (1 per environment)
 ************************************************************************************/

module "secrets-dev" {
  source                 = "../secret-bucket"
  project_name           = "${module.project-application-dev.project_id}"
  service_account_email  = "${module.project-application-dev.service_account_email}"
  service_account_access = "true"
}

module "secrets-int" {
  source                 = "../secret-bucket"
  project_name           = "${module.project-application-int.project_id}"
  service_account_email  = "${module.project-application-int.service_account_email}"
  service_account_access = "true"
}

module "secrets-qe" {
  source                 = "../secret-bucket"
  project_name           = "${module.project-application-qe.project_id}"
  service_account_email  = "${module.project-application-qe.service_account_email}"
  service_account_access = "true"
}

module "secrets-st" {
  source                 = "../secret-bucket"
  project_name           = "${module.project-application-st.project_id}"
  service_account_email  = "${module.project-application-st.service_account_email}"
  service_account_access = "true"
}

module "secrets-prod" {
  source                 = "../secret-bucket"
  project_name           = "${module.project-application-prod.project_id}"
  service_account_email  = "${module.project-application-prod.service_account_email}"
  service_account_access = "true"
  enabled                = "${local.environments["prod"] ? "true" : "false"}"
}

/*************************************************************************************
  Access to Nonprod Shared Secret Buckets
 ************************************************************************************/
locals {
  # These need to correspond in order
  project_service_accounts = [
    "${module.project-application-dev.service_account_email}",
    "${module.project-application-int.service_account_email}",
    "${module.project-application-qe.service_account_email}",
    "${module.project-application-st.service_account_email}",
  ]

  # Workaround for https://github.com/hashicorp/terraform/issues/10857
  project_service_accounts_length = "4"

  shared_secret_buckets = [
    "${data.terraform_remote_state.iam_cicd.shared-secrets-dev-bucket}",
    "${data.terraform_remote_state.iam_cicd.shared-secrets-int-bucket}",
    "${data.terraform_remote_state.iam_cicd.shared-secrets-qe-bucket}",
    "${data.terraform_remote_state.iam_cicd.shared-secrets-st-bucket}",
  ]
}

resource "google_storage_bucket_iam_member" "shared_secrets_sa_access" {
  count  = "${local.project_service_accounts_length}"
  bucket = "${element(local.shared_secret_buckets, count.index)}"
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${element(local.project_service_accounts, count.index)}"
}

/*************************************************************************************
  Access to Prod Shared Secret Bucket
 ************************************************************************************/
resource "google_storage_bucket_iam_member" "shared_secrets_sa_access_prod" {
  count  = "${local.environments["prod"] ? 1 : 0}"
  bucket = "${data.terraform_remote_state.iam_cicd.shared-secrets-prod-bucket}"
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${module.project-application-prod.service_account_email}"
}
