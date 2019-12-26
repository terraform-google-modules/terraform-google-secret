

output "md5hash" {
  description = "Base 64 MD5 hash of the uploaded data."
  value       = google_storage_bucket_object.secret.md5hash
}

output "self_link" {
  description = "A url reference to this object."
  value       = google_storage_bucket_object.secret.self_link
}

output "secret_name" {
  description = "The name of the object(file) the secret stored in"
  value       = google_storage_bucket_object.secret.output_name
}
