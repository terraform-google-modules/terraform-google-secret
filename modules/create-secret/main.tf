resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

locals {

 shared_bucket = "shared-${var.project_id}-${var.env}-secrets"
  app_bucket    = substr("${var.project_id}-${var.application_name}-${var.env}-secrets", 0, 64)
  bucket_name   = var.shared ? local.shared_bucket : local.app_bucket
  object_path   = length(regexall(".+[.](txt|json)$", var.secret)) > 0 ? var.secret : "${var.secret}.txt"


}

resource "google_storage_bucket_object" "secret" {
  depends_on = [null_resource.module_depends_on]
  name   = local.object_path
  source = var.content_file
  bucket = local.bucket_name
}


