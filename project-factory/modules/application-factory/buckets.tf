/*************************************************************************************
  Nonprod Terraform State Bucket
 ************************************************************************************/
resource "google_storage_bucket" "state_bucket_nonprod" {
  name    = "terraform-${var.application_name}-nonprod"
  project = "${local.state_project_nonprod}"

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "state_bucket_nonprod_dev_sa" {
  count  = "${local.environments["dev"] ? 1 : 0}"
  bucket = "${google_storage_bucket.state_bucket_nonprod.name}"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.project-application-dev.service_account_email}"
}

resource "google_storage_bucket_iam_member" "state_bucket_nonprod_int_sa" {
  count  = "${local.environments["int"] ? 1 : 0}"
  bucket = "${google_storage_bucket.state_bucket_nonprod.name}"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.project-application-int.service_account_email}"
}

resource "google_storage_bucket_iam_member" "state_bucket_nonprod_st_sa" {
  count  = "${local.environments["st"] ? 1 : 0}"
  bucket = "${google_storage_bucket.state_bucket_nonprod.name}"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.project-application-st.service_account_email}"
}

resource "google_storage_bucket_iam_member" "state_bucket_nonprod_qe_sa" {
  count  = "${local.environments["qe"] ? 1 : 0}"
  bucket = "${google_storage_bucket.state_bucket_nonprod.name}"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.project-application-qe.service_account_email}"
}

/*************************************************************************************
  Production Terraform State Bucket
 ************************************************************************************/
resource "google_storage_bucket" "state_bucket_prod" {
  count   = "${local.environments["prod"] ? 1 : 0}"
  name    = "terraform-${var.application_name}-prod"
  project = "${local.state_project_prod}"

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "state_bucket_prod_prod_sa" {
  count  = "${local.environments["prod"] ? 1 : 0}"
  bucket = "${google_storage_bucket.state_bucket_prod.name}"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.project-application-prod.service_account_email}"
}
