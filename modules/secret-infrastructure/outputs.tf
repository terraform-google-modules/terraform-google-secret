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

output "app-buckets" {
  description = "The lists of created application-specific buckets"
  value       = [for bucket in google_storage_bucket.app-secrets : bucket.name]
}

output "shared-buckets" {
  description = "The lists of created shared buckets"
  value       = [for bucket in google_storage_bucket.secrets : bucket.name]
}
