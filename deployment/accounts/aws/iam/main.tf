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

module "aws_auth" {
  source = "//modules/auth/aws:aws"

  providers = {
    aws.management = aws
  }

  account_name           = var.name
  pull_request_role_name = "read-only"

  branch_role_names = {
    "main" = "OrganizationAccountAccessRole"
  }

  role_name = "OrganizationAccountAccessRole"
}

provider "aws" {
  alias = "account"

  assume_role {
    role_arn = module.aws_auth.role_arn
  }

  region = "us-east-1"
}

data "aws_organizations_organization" "org" {}
