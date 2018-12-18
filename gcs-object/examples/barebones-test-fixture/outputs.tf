output "foo_id" {
  description = "description"
  value       = "bar"
}

output "project_name" {
  value = "${var.project_name}"
}

output "region" {
  value = "${var.region}"
}

output "contents" {
  description = "description"
  value       = "${module.get_foo.contents}"
}
