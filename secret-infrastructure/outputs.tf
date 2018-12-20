output "app-buckets" {
  value = ["${google_storage_bucket.app-secrets.*.name}"]
}

output "shared-buckets" {
  value = ["${google_storage_bucket.secrets.*.name}"]
}