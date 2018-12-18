output "bucket_name" {
  description = "The name of the bucket created"
  value       = "${google_storage_bucket.secrets.*.name}"
}
