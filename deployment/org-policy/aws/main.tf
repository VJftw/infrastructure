terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias = "management"

  profile = "vjp-management"
  region  = "us-east-1"
}

locals {
  org_id = aws_organizations_organization.org.id

  org_root = [for root in aws_organizations_organization.org.roots : root if root.name == "Root"][0]

  accounts_by_name = {
    for a in aws_organizations_organization.org.accounts :
    a.name => a
  }

  ous_by_name = {
    for ou in aws_organizations_organizational_unit.environment :
    ou.name => ou
  }

  roots_by_name = {
    for r in aws_organizations_organization.org.roots :
    r.name => r
  }
}
