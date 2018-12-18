output "project_id" {
  value = "${local.project_id}"
}

output "domain" {
  value       = "${local.domain}"
  description = "The organization's domain"
}

output "group_email" {
  value       = "${local.gsuite_group ? data.null_data_source.data_final_group_email.outputs["final_group_email"] : ""}"
  description = "The email of the created GSuite group with group_name"
}

output "service_account_id" {
  value       = "${local.s_account_id}"
  description = "The id of the default service account"
}

output "service_account_display_name" {
  value       = "${local.s_account_display_name}"
  description = "The display name of the default service account"
}

output "service_account_email" {
  value       = "${local.s_account_email}"
  description = "The email of the default service account"
}

output "service_account_name" {
  value       = "${local.s_account_name}"
  description = "The fully-qualified name of the default service account"
}

output "service_account_unique_id" {
  value       = "${local.s_account_unique_id}"
  description = "The unique id of the default service account"
}

output "project_bucket_self_link" {
  value       = "${google_storage_bucket.project_bucket.*.self_link}"
  description = "Project's bucket selfLink"
}

output "project_bucket_url" {
  value       = "${google_storage_bucket.project_bucket.*.url}"
  description = "Project's bucket url"
}
