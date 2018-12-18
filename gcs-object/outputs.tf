output "contents" {
  description = "The contents of the requested GCS object"
  value       = "${data.http.remote_contents.body}"
}
