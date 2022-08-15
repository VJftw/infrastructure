terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

locals {
  account_names_to_ids = { for a in data.aws_organizations_organization.org.accounts : a.name => a.id }

  trusted_account_iam_users = {
    "vjp-management" : [
      "vjftw@remote-ws-vjpatel-me",
      "vjftw@Dumbledore",
    ],
  }

  trusted_account_oidc_providers = {
    "vjp-management" : [
      "token.actions.githubusercontent.com",
    ]
  }
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
