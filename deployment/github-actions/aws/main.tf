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
  alias               = "management"
  allowed_account_ids = ["400744676526"]

  region = "us-east-1"
}

data "aws_organizations_organization" "org" {
  provider = aws.management
}

data "aws_caller_identity" "current" {
  provider = aws.management
}


locals {
  account_names_to_ids = {
    for a in data.aws_organizations_organization.org.accounts : a.name => a.id
  }
}
