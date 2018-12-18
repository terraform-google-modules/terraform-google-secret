variable "owner" {
  description = "The username of the individual or group who should own the sandbox (ex. mpell)"
}

variable "credentials_path" {
  description = "The path to a service account JSON key file with permission to create projects"
}

variable "group_owner" {
  description = "Set to 'true' if this project is owned by a group (default 'false')"
  default     = "false"
  type        = "string"
}
