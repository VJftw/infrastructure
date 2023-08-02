resource "google_project_service" "dns" {
  provider = google-beta

  project = "vjp-dns"

  service = "dns.googleapis.com"

  disable_dependent_services = false

  disable_on_destroy = false
}

resource "google_dns_managed_zone" "gcp" {
  provider = google-beta

  project = "vjp-dns"

  name = "vjp-dns"

  dns_name    = "gcp.${aws_route53_zone.root.name}."
  description = "DNS zone for gcp.vjpatel.me"

  labels = {}
}

locals {
  project_subdomains = flatten([
    for project, subdomains in yamldecode(file("gcp_project_domains.yaml")) : [
      for subdomain in subdomains : {
        project   = project,
        subdomain = subdomain,
      }
    ]
  ])
}

resource "google_dns_managed_zone" "project_subdomain" {
  for_each = {
    for ps in local.project_subdomains : "${ps.project}:${ps.subdomain}" => ps
  }

  provider = google-beta

  project = each.value.project

  name = each.value.subdomain

  dns_name    = "${each.value.subdomain}.${google_dns_managed_zone.gcp.dns_name}"
  description = "DNS zone for ${each.value.subdomain}.${google_dns_managed_zone.gcp.dns_name}"

  labels = {}
}

resource "google_dns_record_set" "frontend" {
  for_each = {
    for ps in local.project_subdomains : "${ps.project}:${ps.subdomain}" => ps
  }

  provider = google-beta

  project = "vjp-dns"

  name = google_dns_managed_zone.project_subdomain[each.key].dns_name
  type = "NS"
  ttl  = 86400

  managed_zone = google_dns_managed_zone.gcp.name

  rrdatas = google_dns_managed_zone.project_subdomain[each.key].name_servers
}
