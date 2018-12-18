credentials_file_path = "/vagrant/terraform.json"

impersonated_user_email = "lucas@lnescidev.com"

oauth_scopes = [
  "https://www.googleapis.com/auth/admin.directory.group",
  "https://www.googleapis.com/auth/admin.directory.group.member",
]

organization_id= "65779779009"

# prod-gke variables
name_prod_gke = "gcp-clef-prod-gke1"

org_id_prod_gke = "65779779009"

billing_account_prod_gke = "01E9AF-2083CE-BC668D"

group_role_prod_gke = "roles/owner"

folder_id_prod_gke = "886025180534"

labels_prod_gke = {
  "enviroment" = "prod"
}

# project-factory variables
name_factory = "pf-test-090318-01"

org_id_factory = "65779779009"

usage_bucket_name_factory = "pf-test-090318-11-usage-report-bucket"

billing_account_factory = "01E9AF-2083CE-BC668D"

group_role_factory = "roles/owner"

shared_vpc_factory = "lnesci-xpn-host"

sa_group_factory = "test_sa_group@lnescidev.com"

folder_id_factory = "886025180534"
