
locals {
}

/******************************************
  Provider configuration
 *****************************************/
provider "google" {
  credentials = "${file(var.credentials_file_path)}"
}


resource "google_storage_bucket" "secrets" {
  count = "${length(var.env_list)}"
  name          = "shared-${var.project_name}-${element(var.env_list, count.index)}-secrets"
  storage_class = "MULTI_REGIONAL"
  project = "${var.project_name}"
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "app-secrets" {
  count = "${length(var.application_list) * length(var.env_list)}"
  name          = "${element(var.application_list, count.index)}-${element(var.env_list, (count.index % length(var.env_list)))}-secrets"
  storage_class = "MULTI_REGIONAL"
  project = "${var.project_name}"
  versioning {
    enabled = true
  }
}
