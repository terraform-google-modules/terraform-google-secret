
locals {
  app_list = ["app1${var.random_suffix}", "app2${var.random_suffix}"]
  env_list = ["dev", "qa", "prod"]
}

module "create-buckets" {
  source = "../../../"
  project_name = "${var.project_name}"
  application_list = "${local.app_list}"
  env_list = "${local.env_list}"
  credentials_file_path = "${var.credentials_file_path}"
}
