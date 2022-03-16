# CDN backend
resource "google_compute_backend_bucket" "frontend" {
  name        = "${var.project}-backend"
  bucket_name = google_storage_bucket.website.name
  enable_cdn  = true
}

# Reserve an external IP
resource "google_compute_global_address" "frontend" {
  name = "${var.project}-ip"
  depends_on = [
    google_compute_project_default_network_tier.default
  ]
}

# maps http proxy to the CDN bucket
resource "google_compute_url_map" "frontend" {
  name            = "${var.project}-map"
  default_service = google_compute_backend_bucket.frontend.self_link
}

# http proxy targeted by the reserved IP
resource "google_compute_target_http_proxy" "frontend" {
  name    = "${var.project}-proxy"
  url_map = google_compute_url_map.frontend.id
}

# premium required in order to use storage buckets as CDN target
resource "google_compute_project_default_network_tier" "default" {
  network_tier = "PREMIUM"
}

# GCP forwarding rule
resource "google_compute_global_forwarding_rule" "frontend" {
  name                  = "${var.project}-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.frontend.address
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.frontend.id
}
