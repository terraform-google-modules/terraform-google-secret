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
  app_list = ["app1${var.random_suffix}", "app2${var.random_suffix}"]
  env_list = ["dev", "qa", "prod"]
}

module "create-buckets" {
  source                = "../../../"
  project_name          = "${var.project_name}"
  application_list      = "${local.app_list}"
  env_list              = "${local.env_list}"
  credentials_file_path = "${var.credentials_file_path}"
}
