terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

locals {
  repositories = yamldecode(file("repositories.yaml"))
}

provider "aws" {
  region = "us-east-1"
}

data "aws_organizations_organization" "org" {
  provider = aws
}

locals {
  account_names_to_ids = {
    for a in data.aws_organizations_organization.org.accounts : a.name => a.id
  }
}

data "external" "aws_auth" {
  program = [
    "aws-cross-account", 
    "--account_name=vjp-management",
    "--pull_request_role_name=read-only",
    "--branch_role_name=main:administrator",
    "--role_name=administrator",
  ]
}

provider "aws" {
  alias = "management"

  profile = data.external.aws_auth.result.profile

  region = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.management
}
