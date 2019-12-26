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

/******************************************
  Provider configuration
 *****************************************/

locals {
  shared_bucket = "shared-${var.project_id}-${var.env}-secrets"
  app_bucket    = substr("${var.project_id}-${var.application_name}-${var.env}-secrets", 0, 64)
  bucket_name   = var.shared ? local.shared_bucket : local.app_bucket
  object_path   = length(regexall(".+[.](txt)$", var.secret)) > 0 ? var.secret : "${var.secret}.txt"
}

module "secret" {
  source = "./modules/gcs-object"
  bucket = local.bucket_name
  path   = local.object_path

}
