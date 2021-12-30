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

provider "aws" {
  alias = "management"

  assume_role {
    role_arn = "arn:aws:iam::${local.account_names_to_ids["vjp-management"]}:role/administrator"
  }

  region = "us-east-1"
}

data "aws_caller_identity" "current" {
  provider = aws.management
}
