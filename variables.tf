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

variable "credentials_file_path" {
  description = "The path to the GCP credentials"
}

variable "application_name" {
  description = "The application to fetch secrets for"
}

variable "env" {
  description = "The environment to fetch secrets for"
}

variable "secret" {
  description = "The name of the secret to fetch"
}

variable "shared" {
  description = "Will we fetch the secret from the shared bucket instead of an application-specific bucket?"
  type        = "string"
  default     = "false"
}
