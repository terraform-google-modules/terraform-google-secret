locals {
  enabled = "${(var.enabled != "true") ? false : true}"
}

resource "google_storage_bucket" "secrets" {
  count         = "${local.enabled ? 1 : 0}"
  name          = "${var.project_name}-secrets"
  project       = "${local.secrets_project}"
  storage_class = "MULTI_REGIONAL"

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "secrets_bucket_sa" {
  count  = "${(local.enabled && (var.service_account_access == "true")) ? 1 : 0}"
  bucket = "${google_storage_bucket.secrets.name}"
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.service_account_email}"
}
