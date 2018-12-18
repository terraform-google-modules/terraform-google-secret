data "google_storage_object_signed_url" "file_url" {
  bucket   = "${var.bucket}"
  path     = "${var.path}"
  duration = "${var.duration}"
}

data "http" "remote_contents" {
  url = "${data.google_storage_object_signed_url.file_url.signed_url}"
}
