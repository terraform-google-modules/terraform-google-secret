output "app-buckets" {
  value = ["${module.create-buckets.app-buckets}"]
}

output "shared-buckets" {
  value = ["${module.create-buckets.shared-buckets}"]
}