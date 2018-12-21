output "app-buckets" {
  value = ["${module.create-buckets.app-buckets}"]
}

output "shared-buckets" {
  value = ["${module.create-buckets.shared-buckets}"]
}

output "app-list" {
  value = "${local.app_list}"
}

output "env-list" {
  value = "${local.env_list}"
}

output "project-name" {
  value = "${var.project_name}"
}