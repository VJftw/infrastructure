resource "google_project_service" "dns" {
  provider = google-beta

  project = "vjp-dns"

  service = "dns.googleapis.com"

  disable_dependent_services = true
}

resource "google_dns_managed_zone" "gcp" {
  provider = google-beta

  project = "vjp-dns"

  name = "vjp-dns"

  dns_name    = "gcp.${aws_route53_zone.root.name}."
  description = "DNS zone for gcp.vjpatel.me"

  labels = {}
}
