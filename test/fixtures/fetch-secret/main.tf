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

locals {
  app_name     = "app1${var.random_suffix}"
  app_list     = ["app1${var.random_suffix}", "app2${var.random_suffix}"]
  env_list     = ["dev", "qa", "prod"]
  file_path    = "${path.module}/file.txt"
  file_content = "${file(local.file_path)}"
}

provider "google" {
  credentials = "${file(var.credentials_file_path)}"
}


resource "google_storage_bucket_object" "test-object" {
  name    = "test-secret.txt"
  content = "${local.file_content}"
  bucket  = "${element(module.create-buckets.app-buckets,0)}"
}

module "create-buckets" {
  source                = "../../../modules/secret-infrastructure"
  project_id          = "${var.project_name}"
  credentials_file_path = "${var.credentials_file_path}"
  application_list      = "${local.app_list}"
  env_list              = "${local.env_list}"
}

module "fetch-secret-test" {
  source                = "../../../"
  credentials_file_path = "${var.credentials_file_path}"
  application_name      = "${local.app_name}"
  secret                = "test-secret"
  env                   = "dev"
}
