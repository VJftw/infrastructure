#!/usr/bin/env bash
# This script will onboard and manage accounts.
set -Eeuo pipefail

source "//build/util"
source "//build/ci/terraform:env"

# Apply accounts
util::info "Converging Accounts"
./pleasew query alltargets --include terraform_workspace,accounts | ./pleasew run parallel --output=group_immediate -a "
terraform init -lock=true -lock-timeout=30s && \
terraform apply -refresh=true -compact-warnings -lock=true -lock-timeout=30s -auto-approve
" -
util::green "Converged Accounts"

# Apply AWS accounts IAM
util::info "Converging IAM"
./pleasew query alltargets --include terraform_workspace //deployment/accounts/aws/iam/... | ./pleasew run parallel --output=group_immediate -a "
terraform init -lock=true -lock-timeout=30s && \
terraform apply -refresh=true -compact-warnings -lock=true -lock-timeout=30s -auto-approve
" -
util::green "Converged IAM"
