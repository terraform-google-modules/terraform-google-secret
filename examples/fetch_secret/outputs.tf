output "mysecret" {
  value = "${module.mysecret.contents}"
  sensitive = true
}