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

variable "application_name" {
  description = "The application to create secret for. Could be `null` for shared secrets"
  default = null
}

variable "env" {
  description = "The environment to create secret for"
}

variable "secret" {
  description = "The name of the secret to create. The both forms `secret_name` and `secret_name.txt` are valid"
}

variable "content_file" {
  description = "The content file path"
}

variable "shared" {
  description = "Will we push the secret to the shared bucket instead of an application-specific bucket?"
  type        = bool
  default     = false
}

variable "project_id" {
  description = "The id of the project sectre buckets belong to"
  type        = string
}

variable "module_depends_on" {
  description = "The workaround for module dependencies. For example, could be used to wait before the bucket is created"
  default     = []
  type        = "list"
}
