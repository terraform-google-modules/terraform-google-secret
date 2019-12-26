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

output "app_buckets" {
  value       = module.example.app_buckets
  description = "The lists of created application-specific buckets"
}

output "shared_buckets" {
  value       = module.example.shared_buckets
  description = "The lists of created shared buckets"
}

output "app_secret" {
  description = "The name of the secret1 to use in tests"
  value       = module.example.app_secret
}

output "shared_secret" {
  description = "The name of the secret1 to use in tests"
  value       = module.example.shared_secret
}

output "project_id" {
  value = var.project_id
}
