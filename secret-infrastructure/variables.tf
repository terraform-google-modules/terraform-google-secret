variable "application_list" {
  description = "The list of application names that will store secrets"
  type = "list"
  default = []
}

variable "env_list" {
  description = "The list of environments for secrets"
  type = "list"
  default = []
}

variable "project_name" {
  description = "The name of the project this applies to"
}
variable "credentials_file_path" {
  description = "GCP credentials fils"
}
