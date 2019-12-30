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

// create infrastructure for secret-storages
module "secret_storage" {
  source           = "../../modules/secret-infrastructure"
  project_id       = var.project_id
  application_list = ["app1", "app100500"]
  env_list         = ["dev", "qa", "prod"]
}

// Create secrets
module "app_secret" {
  source = "../../modules/create-secrets"

  module_depends_on = module.secret_storage.shared-buckets
  secrets_file      = "${path.module}/secrets.json"
  project_id        = var.project_id
}
