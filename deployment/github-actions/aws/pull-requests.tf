locals {
  repository_prs = flatten([
    for gh_repo, config in local.repositories : {
      repo = gh_repo,
    }
  ])

  repository_pr_accounts_roles = flatten([
    for gh_repo, config in local.repositories : {
      repo           = gh_repo,
      accounts_roles = lookup(lookup(config, "pull_requests", {}), "accounts", {})
    }
  ])

}

resource "aws_iam_role" "pr" {
  provider = aws.management

  for_each = {
    for rb in local.repository_prs : rb.repo => rb
  }

  # ghapr = GitHub Actions Pull Request
  name        = "ghapr-${lower(replace(each.value.repo, "/\\.|//", "-"))}"
  description = "Github Actions for Pull Requests on '${each.value.repo}'"

  tags = {
    "github.com/repository" = each.value.repo
  }

  assume_role_policy = data.aws_iam_policy_document.pr_assume_role_policy[each.value.repo].json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess", # Let's us obtain Account IDs by Account Names
    aws_iam_policy.pr[each.value.repo].arn,
  ]
}

data "aws_iam_policy_document" "pr_assume_role_policy" {
  provider = aws.management

  for_each = {
    for rb in local.repository_prs : rb.repo => rb
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
      values   = ["repo:${each.value.repo}:pull_request"]
    }
  }
}

data "aws_iam_policy_document" "pr_policy" {
  provider = aws.management

  for_each = {
    for rb in local.repository_pr_accounts_roles : rb.repo => rb
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

resource "aws_iam_policy" "pr" {
  provider = aws.management

  for_each = {
    for rb in local.repository_pr_accounts_roles : rb.repo => rb
  }

  name        = "ghapr-${lower(replace(each.value.repo, "/\\.|//", "-"))}"
  path        = "/"
  description = "Github Actions for Pull Requests on '${each.value.repo}'"

  policy = data.aws_iam_policy_document.pr_policy[each.value.repo].json
}

# resource "aws_iam_policy_attachment" "pr" {
#   provider = aws.management

#   for_each = {
#     for rb in local.repository_pr_accounts_roles : rb.repo => rb
#   }

#   name = "ghapr-${lower(replace(each.value.repo, "/\\.|//", "-"))}"

#   roles      = [aws_iam_role.pr[each.value.repo].name]
#   policy_arn = aws_iam_policy.pr[each.value.repo].arn
# }
