locals {
  repository_branches = flatten([
    for gh_repo, config in local.repositories : [
      for branch, branch_config in lookup(config, "branches", {}) : {
        repo   = gh_repo,
        branch = branch,
      }
    ]
  ])

  repository_branch_accounts_roles = flatten([
    for gh_repo, config in local.repositories : [
      for branch, branch_config in lookup(config, "branches", {}) : {
        repo           = gh_repo,
        branch         = branch,
        accounts_roles = lookup(branch_config, "accounts", {})
      }
    ]
  ])

}

resource "aws_iam_role" "branch" {
  provider = aws.management

  for_each = {
    for rb in local.repository_branches : "${rb.repo}:${rb.branch}" => rb
  }

  name        = "gha-${lower(replace(each.value.repo, "/\\.|//", "-"))}-${each.value.branch}"
  description = "Github Actions for '${each.value.repo}' on '${each.value.branch}'"

  tags = {
    "github.com/repository" = each.value.repo
    "github.com/branch"     = each.value.branch
  }

  assume_role_policy = data.aws_iam_policy_document.branch_assume_role_policy["${each.value.repo}:${each.value.branch}"].json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess", # Let's us obtain Account IDs by Account Names
    aws_iam_policy.branch["${each.value.repo}:${each.value.branch}"].arn,
  ]
}

data "aws_iam_policy_document" "branch_assume_role_policy" {
  provider = aws.management

  for_each = {
    for rb in local.repository_branches : "${rb.repo}:${rb.branch}" => rb
  }

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [
        format(
          "arn:aws:iam::%s:oidc-provider/token.actions.githubusercontent.com",
          data.aws_caller_identity.current.account_id
        )
      ]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${each.value.repo}:ref:refs/heads/${each.value.branch}"]
    }
  }
}

data "aws_iam_policy_document" "branch_policy" {
  provider = aws.management

  for_each = {
    for rb in local.repository_branch_accounts_roles : "${rb.repo}:${rb.branch}" => rb
  }

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    # Supports referencing account names which don't exist yet (eventual consistency)
    resources = compact(flatten([
      for account, roles in each.value.accounts_roles : [
        lookup(local.account_names_to_ids, account, "") == "" ? [] : formatlist("arn:aws:iam::${local.account_names_to_ids[account]}:role/%s", roles)
      ]
    ]))
  }
}

resource "aws_iam_policy" "branch" {
  provider = aws.management

  for_each = {
    for rb in local.repository_branch_accounts_roles : "${rb.repo}:${rb.branch}" => rb
  }

  name        = "gha-${lower(replace(each.value.repo, "/\\.|//", "-"))}-${each.value.branch}"
  path        = "/"
  description = "Github Actions for '${each.value.repo}' on '${each.value.branch}'"

  policy = data.aws_iam_policy_document.branch_policy["${each.value.repo}:${each.value.branch}"].json
}
