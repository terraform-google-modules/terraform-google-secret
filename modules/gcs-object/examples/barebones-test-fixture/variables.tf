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
  description = "path to creds"
}

variable "project_name" {
  description = "name of the GCP project to create resources within"
}

variable "environment" {
  description = "the environment in which we create the test resources"
  default     = "dev"
}

variable "region" {
  description = "Region in which we create resources"
  default     = "us-west1"
}
