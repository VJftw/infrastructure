#!/usr/bin/env bash
# This script will onboard and manage accounts.
set -Eeuo pipefail

source "//build/util"
source "//build/ci/terraform:env"

# Apply accounts
mapfile -t account_tf_roots < <(./pleasew query alltargets --include terraform_workspace,accounts)
for account_tf_root in "${account_tf_roots[@]}"; do
    util::info "Running 'terraform apply' for ${account_tf_root}"

    ./pleasew run -p "${account_tf_root}" -- "
    terraform init -lock=true -lock-timeout=30s && \
    terraform apply -refresh=true -compact-warnings -lock=true -lock-timeout=30s -auto-approve
    "
done


# Apply AWS accounts IAM
mapfile -t iam_tf_roots < <(./pleasew query alltargets --include terraform_workspace //deployment/accounts/aws/iam/...)
for iam_tf_root in "${iam_tf_roots[@]}"; do
    util::info "Running 'terraform apply' for ${iam_tf_root}"

    ./pleasew run -p "${iam_tf_root}" -- "
    terraform init -lock=true -lock-timeout=30s && \
    terraform apply -refresh=true -compact-warnings -lock=true -lock-timeout=30s -auto-approve
    "
done
