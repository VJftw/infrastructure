terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
      configuration_aliases = [ aws.management ]
    }
     environment = {
      source = "EppO/environment"
      version = "1.2.0"
    }
  }
}

data "aws_caller_identity" "current" {
  provider = aws.management
}

data "aws_organizations_organization" "org" {
  provider = aws.management
}

data "environment_variables" "github_ref_name" {
  filter = "^GITHUB_REF_NAME$"
}


locals {
  account_names_to_ids = {
    for a in data.aws_organizations_organization.org.accounts : a.name => a.id
  }

  target_account_id = local.account_names_to_ids[var.account_name]

  // Pull Requests
  is_pull_request = length(regexall("role/ghapr", data.aws_caller_identity.current.arn)) == 1
  pull_request_role_name = var.pull_request_role_name
  
  // Branches
  is_branch = length(regexall("role/gha", data.aws_caller_identity.current.arn)) == 1
  branch_name = (!local.is_pull_request && local.is_branch) ? data.environment_variables.github_ref_name.items["GITHUB_REF_NAME"] : ""
  branch_role_name = (!local.is_pull_request && local.is_branch) ? var.branch_role_names[local.branch_name] : ""

  // Non CICD
  is_non_cicd = !local.is_pull_request && !local.is_branch 
  non_cicd_role_name = var.role_name

  target_role = local.is_pull_request ? local.pull_request_role_name : local.is_branch ? local.branch_role_name : local.non_cicd_role_name
}
