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


resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

locals {
  source = jsondecode(file(var.secrets_file))

  shared_secrets     = [for secret in local.source : secret if secret.shared]
  shared_secrets_map = { for x in local.shared_secrets : "${x.secret_name}-${x.env}" => x }

  secrets     = [for secret in local.source : secret if ! secret.shared]
  secrets_map = { for x in local.secrets : "${x.secret_name}-${x.application_name}-${x.env}" => x }


}


resource "google_storage_bucket_object" "shared_secret" {
  depends_on = [null_resource.module_depends_on]
  for_each   = local.shared_secrets_map
  name       = "${each.value.secret_name}.txt"
  content    = each.value.secret_value
  bucket     = substr("shared-${var.project_id}-${each.value.env}-secrets", 0, 64)
}

resource "google_storage_bucket_object" "secret" {
  depends_on = [null_resource.module_depends_on]
  for_each   = local.secrets_map
  name       = "${each.value.secret_name}.txt"
  content    = each.value.secret_value
  bucket     = substr("${var.project_id}-${each.value.application_name}-${each.value.env}-secrets", 0, 64)
}
