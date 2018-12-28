/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {}

/******************************************
  Provider configuration
 *****************************************/
provider "google" {
  credentials = "${file(var.credentials_file_path)}"
}

resource "google_storage_bucket" "secrets" {
  count         = "${length(var.env_list)}"
  name          = "shared-${var.project_name}-${element(var.env_list, count.index)}-secrets"
  storage_class = "MULTI_REGIONAL"
  project       = "${var.project_name}"

  versioning {
    enabled = true
  }

  force_destroy = true
}

resource "google_storage_bucket" "app-secrets" {
  count         = "${length(var.application_list) * length(var.env_list)}"
  name          = "${element(var.application_list, count.index)}-${element(var.env_list, (count.index % length(var.env_list)))}-secrets"
  storage_class = "MULTI_REGIONAL"
  project       = "${var.project_name}"

  versioning {
    enabled = true
  }

  force_destroy = true
}
