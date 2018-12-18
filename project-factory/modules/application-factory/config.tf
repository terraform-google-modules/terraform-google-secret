locals {
  organization_id   = ""
  billing_account   = ""
  usage_bucket_name = "gcp-foundation-billing-export"
  group_prefix      = "gcp-auto-"
  sa_group          = "${local.group_prefix}service_accounts-all@example.com"
  api_sa_group      = "${local.group_prefix}service_accounts-api@example.com"
}

locals {
  state_project_nonprod = "cicd-nonprod"
  state_project_prod    = "cicd-prod"
}

locals {
  secrets_project = "secrets"
}

# The folders to place created projects in
locals {
  folder_dev  = ""
  folder_prod = ""
}

# Shared VPCs for different environments
locals {
  xpn_dev  = "network-dev"

}

# Subnets for different environments
locals {
  subnets_dev = [
    "projects/${local.xpn_dev}/regions/us-central1/subnetworks/test-us-central1-private",
    "projects/${local.xpn_dev}/regions/us-west1/subnetworks/test-us-west1-private",
  ]

}

# Usage bucket exports
locals {
  usage_bucket_dev  = "usage-reports"

}
