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
module "secret-storage" {
  source                = "../../modules/secret-infrastructure"
  project_id          = var.project_id
  application_list      = ["app1", "app2", "app3"]
  env_list              = ["dev","qa","prod"]
}

// Create secrets
module "secret" {
  source = "../../modules/create-secret"

  module_depends_on = module.secret-storage.shared-buckets
  application_name = "app1"
  env = "qa"
  secret = "secret1"
  content_file = "${path.module}/secrets/secret1.txt"
  shared = false
  project_id = var.project_id
}

module "shared_secret" {
  source = "../../modules/create-secret"

  module_depends_on = module.secret-storage.shared-buckets
  application_name = ""
  env = "dev"
  secret = "secret2.txt"
  content_file = "${path.module}/secrets/secret2.txt"
  shared = true
  project_id = var.project_id
}

// fetch secret
module "fetch_secret" {
  source = "../.."
  application_name = "app1"
  env = "qa"
  secret = module.secret.secret_name
  shared = false
  project_id = var.project_id
}

module "fetch_shared_secret" {
  source = "../.."
  application_name = ""
  env = "dev"
  secret = module.shared_secret.secret_name
  shared = true
  project_id = var.project_id
}


output "content" {
  value = module.fetch_shared_secret.contents
}