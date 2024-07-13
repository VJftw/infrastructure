variable "domain" {
  type = string
  description = "The domain to set up and configure email for."
}

variable "zone_id" {
  type = string
  description = "The Route 53 Zone ID to add records to."
}
