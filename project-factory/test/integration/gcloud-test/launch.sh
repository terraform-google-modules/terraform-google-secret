#!/bin/bash

#################################################################
#   PLEASE FILL THE VARIABLES WITH VALID VALUES FOR TESTING     #
#   DO NOT REMOVE ANY OF THE VARIABLES                          #
#################################################################

export PROJECT_NAME="pf-test-integration"
export PROJECT_RANDOM_ID="true"
export ORG_ID="65779779009"
export GROUP_NAME="test-group$RANDOM"
export FOLDER_ID=""
export BILLING_ACCOUNT="01E9AF-2083CE-BC668D"
export GROUP_ROLE="roles/editor"
export SHARED_VPC="lnesci-xpn-host"
export SA_GROUP="test_sa_group@lnescidev.com"
export USAGE_BUCKET_NAME="usage-report-bucket-pf-test-200318"
export GSUITE_ADMIN_ACCOUNT="lucas@lnescidev.com"
export CREDENTIALS_PATH="/opt/terraform/test5/terraform2.json"
export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=$CREDENTIALS_PATH

# Cleans the workdir
function clean_workdir() {
  echo "Cleaning workdir"
  yes | rm -f terraform.tfstate*
  yes | rm -f *.tf
  yes | rm -rf .terraform
}

# Creates the main.tf file for Terraform
function create_main_tf_file() {
  echo "Creating main.tf file"
  touch main.tf
  cat <<EOF > main.tf
locals {
  credentials_file_path    = "$CREDENTIALS_PATH"
}

provider "google" {
  credentials              = "\${file(local.credentials_file_path)}"
}

provider "gsuite" {
  credentials              = "\${file(local.credentials_file_path)}"
  impersonated_user_email  = "$GSUITE_ADMIN_ACCOUNT"
  oauth_scopes             = [
                               "https://www.googleapis.com/auth/admin.directory.group",
	                           "https://www.googleapis.com/auth/admin.directory.group.member"
                             ]
}
module "project-factory" {
  source                   = "../../../"
  name                     = "$PROJECT_NAME"
  random_project_id        = "$PROJECT_RANDOM_ID"
  org_id                   = "$ORG_ID"
  usage_bucket_name        = "$USAGE_BUCKET_NAME"
  billing_account          = "$BILLING_ACCOUNT"
  group_role               = "$GROUP_ROLE"
  group_name               = "$GROUP_NAME"
  shared_vpc               = "$SHARED_VPC"
  sa_group                 = "$SA_GROUP"
  folder_id                = "$FOLDER_ID"
  credentials_path         = "\${local.credentials_file_path}"
}
EOF
}

# Creates the outputs.tf file
function create_outputs_file() {
  echo "Creating outputs.tf file"
  touch outputs.tf
  cat <<'EOF' > outputs.tf
output "project_info_example" {
  value       = "${module.project-factory.project_id}"
}

output "domain_example" {
  value       = "${module.project-factory.domain}"
}

output "group_email_example" {
  value       = "${module.project-factory.group_email}"
}
EOF
}

# Preparing environment
clean_workdir
create_main_tf_file
create_outputs_file

# Call to bats
echo "Test to execute: $(bats integration.bats -c)"
bats integration.bats

export CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE=""
unset CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE

# Clean the environment
clean_workdir
echo "Integration test finished"
