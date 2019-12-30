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

variable "secrets_file" {
  description = "The path to `json` file with defined secrets. The json should be a list of objects with next keys: `secret_name`, `secret_value`, `application_name`, `env`, and `shared`"
}

variable "project_id" {
  description = "The id of the project secret buckets belong to"
  type        = string
}

variable "module_depends_on" {
  description = "The workaround for module dependencies. For example, could be used to wait before the bucket is created"
  default     = []
  type        = "list"
}
