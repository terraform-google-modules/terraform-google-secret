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
//  credentials = "${file(var.credentials_file_path)}"
}

resource "google_storage_bucket" "secrets" {
  for_each = toset([for env in var.env_list : substr(format("shared-%s-%s-secrets", var.project_id, env),0,64)])
  name          = each.key
  storage_class = "MULTI_REGIONAL"
  project       = var.project_id

  versioning {
    enabled = true
  }

  force_destroy = true
}

resource "google_storage_bucket" "app-secrets" {
  for_each      = toset([ for s in setproduct(var.application_list, var.env_list) : substr(format("%s-%s-%s-secrets", var.project_id, s[0], s[1]), 0, 64)])
  name          = each.key
  storage_class = "MULTI_REGIONAL"
  project       = var.project_id

  versioning {
    enabled = true
  }

  force_destroy = true
}
