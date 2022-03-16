output "bucket_url" {
  value = google_storage_bucket.website.self_link
}

output "cdn_url" {
  value = "http://${google_compute_global_address.frontend.address}"
}
