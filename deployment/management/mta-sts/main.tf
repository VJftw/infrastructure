provider "aws" {
  profile = "vjp-management"
  region  = "us-east-1"
}

module "mta-sts" {
  source = "//modules/mta-sts/aws:aws"

  providers = {
    aws = aws
  }

  domain = "vjpatel.me"
  tls_report_email_address = "smtp-tls-reports@vjpatel.me"
  mta_sts_id = "1714671831024"
}
