variable domain {
  type = string
  description = "The domain to configure MTA-STS for."
}

variable tls_report_email_address {
  type = string
  description = "The email address to send SMTP TLS reports to."
}

variable mta_sts_id {
  type = string
  description = "The id for the text record in MTA-STS."
}
