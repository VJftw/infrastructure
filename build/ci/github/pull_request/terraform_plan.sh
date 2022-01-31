#!/usr/bin/env bash
# This script will plan Terraform configuration changes to the 'default' workspace.
set -Eeuo pipefail

source "//build/util"
source "//third_party/sh:shflags"
source "//build/ci/terraform:env"

DEFINE_string 'please_target' '' 'Please terraform_root target to use (required)' 't'

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

if [ -z "${FLAGS_please_target}" ]; then
    flags_help
    exit 1
fi

REPO_ROOT="$(./pleasew query reporoot)"
OPA_BINARY="$REPO_ROOT///third_party/binary:opa"
OPA_BUNDLE="$REPO_ROOT///policy/terraform"


util::info "Running 'terraform plan' for ${FLAGS_please_target}"

./pleasew run -p "$FLAGS_please_target" -- "
terraform init -lock=false && \
terraform plan -refresh=false -compact-warnings -lock=false -out=tfplan.out && \
terraform show -json tfplan.out > tfplan.json && \
$OPA_BINARY eval --fail-defined --format pretty --bundle $OPA_BUNDLE --input tfplan.json 'data.terraform.analysis.deny[x]'
# if the OPA tool prints 'undefined', it is happy... It will print a table of errors if it is not happy.
"

util::success "Terraform plan for ${FLAGS_please_target} is OK!"
