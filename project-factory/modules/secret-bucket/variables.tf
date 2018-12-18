variable "project_name" {
  description = "The project to store secrets for"
}

variable "service_account_email" {
  description = "The Service Account to get access"
  default     = ""
}

variable "service_account_access" {
  description = "Gives a service account access if `true` (default `false`)"
  default     = "false"
}

variable "enabled" {
  description = "Enabled the module if `true` (default `true`)"
  default     = "true"
  type        = "string"
}
