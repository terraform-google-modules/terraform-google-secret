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

//output "app-buckets" {
//  value = ["${module.create-buckets.app-buckets}"]
//}
//
//output "shared-buckets" {
//  value = ["${module.create-buckets.shared-buckets}"]
//}

output "app-list" {
  value = "${local.app_list}"
}

output "env-list" {
  value = "${local.env_list}"
}

output "project-name" {
  value = "${var.project_name}"
}

output "mysecret" {
  value     = "${module.fetch-secret-test.contents}"
  sensitive = false
}
