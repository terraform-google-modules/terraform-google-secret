credentials_file_path = "/vagrant/terraform7.json"

impersonated_user_email = "lucas@lnescidev.com"

oauth_scopes = [
  "https://www.googleapis.com/auth/admin.directory.group",
  "https://www.googleapis.com/auth/admin.directory.group.member",
]

random_project_id = "true"

name = "pf-test-smoke"

org_id = "65779779009"

usage_bucket_name = "usage-report-bucket-pf-test-200318"

billing_account = "01E9AF-2083CE-BC668D"

group_role = "roles/editor"

shared_vpc = "lnesci-xpn-host"

sa_group = "test_sa_group@lnescidev.com"

api_sa_group = "api_sa_group@lnescidev.com"

folder_id = ""

create_group = "true"

group_name = "my_gsuite_group_fake_16apr18-1"

shared_vpc_subnets = [
  "projects/base-project-196723/regions/us-east1/subnetworks/default",
  "projects/base-project-196723/regions/us-central1/subnetworks/default",
  "projects/base-project-196723/regions/us-central1/subnetworks/subnet-1",
]

labels = {
  "label1" = "value1"
  "label2" = "value2"
}

api_sa_group = "api_sa_group@lnescidev.com"

bucket_project = "base-project-196723"

bucket_name = "my_fake_bucket_16apr18-1"
