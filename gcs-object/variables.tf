variable "bucket" {
  description = "The bucket to fetch the object from"
}

variable "path" {
  description = "The path to the desired object within the bucket"
}

variable "duration" {
  description = "The duration of the signed URL (defaults to 1m)"
  default     = "1m"
}
