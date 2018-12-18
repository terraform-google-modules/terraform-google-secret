output "project_info_example" {
  value = "${module.project-factory.project_id}"
}

output "domain_example" {
  value = "${module.project-factory.domain}"
}

output "group_email_example" {
  value = "${module.project-factory.group_email}"
}

output "project_bucket_url" {
  value = "${module.project-factory.project_bucket_url}"
}
