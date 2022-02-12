terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

locals {
  trusted_account_names = [
    "vjp-management", # we only keep identities in the management account.
  ]
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias = "account"

  profile = var.name

  region = "us-east-1"
}

data "aws_organizations_organization" "org" {
  provider = aws
}
