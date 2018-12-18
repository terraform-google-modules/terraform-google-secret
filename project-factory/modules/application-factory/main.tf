locals {
  is_group_owner = "${var.group_owner == "true" ? true : false}"

  environments = {
    dev  = "${contains(var.environments, "dev")}"
    int  = "${contains(var.environments, "int")}"
    qe   = "${contains(var.environments, "qe")}"
    st   = "${contains(var.environments, "st")}"
    prod = "${contains(var.environments, "prod")}"
  }
}
