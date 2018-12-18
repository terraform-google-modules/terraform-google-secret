output "project_id_dev" {
  description = "The ID of the dev project created"
  value       = "${module.project-application-dev.project_id}"
}

output "project_id_int" {
  description = "The ID of the integration project created"
  value       = "${module.project-application-int.project_id}"
}

output "project_id_st" {
  description = "The ID of the staging project created"
  value       = "${module.project-application-st.project_id}"
}

output "project_id_qe" {
  description = "The ID of the QE project created"
  value       = "${module.project-application-qe.project_id}"
}

output "project_id_prod" {
  description = "The ID of the prod project created"
  value       = "${module.project-application-prod.project_id}"
}

/*************************************************************************************
  Secrets Buckets
 ************************************************************************************/
output "secrets-dev" {
  description = "The name of the dev secrets bucket"
  value       = "${module.secrets-dev.bucket_name}"
}

output "secrets-int" {
  description = "The name of the int secrets bucket"
  value       = "${module.secrets-int.bucket_name}"
}

output "secrets-qe" {
  description = "The name of the qe secrets bucket"
  value       = "${module.secrets-qe.bucket_name}"
}

output "secrets-st" {
  description = "The name of the st secrets bucket"
  value       = "${module.secrets-st.bucket_name}"
}

output "secrets-prod" {
  description = "The name of the prod secrets bucket"
  value       = "${module.secrets-prod.bucket_name}"
}
