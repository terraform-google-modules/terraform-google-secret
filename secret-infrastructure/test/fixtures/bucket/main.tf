
module "create-buckets" {
  source = "../../../"
  project_name = "${var.project_name}"
  application_list = ["app1${var.random_suffix}", "app2${var.random_suffix}"]
  env_list = ["dev", "qa", "prod"]
  credentials_file_path = "${var.credentials_file_path}"
}
