name = "viewer"

aws_managed_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess",
]

gcp_managed_roleset = [
    "roles/viewer",
]
