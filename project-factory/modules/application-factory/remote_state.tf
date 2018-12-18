data "terraform_remote_state" "iam_cicd" {
  backend = "gcs"

  config {
    bucket = "terraform-iam-prod"
    prefix = "state/iam/cicd"
  }
}
