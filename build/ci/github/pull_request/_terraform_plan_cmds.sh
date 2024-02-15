#!/usr/bin/env bash
# This script will run Terraform against the 'default' workspace.
set -Eeuo pipefail

source "//build/util"
source "//third_party/sh:shflags"
source "//build/ci/terraform:env"

OPA_EVAL="//policy/terraform:terraform_eval"

DEFINE_string 'opa_data' '' 'input data to pass to OPA (required)' 'd'

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

if [ -z "${FLAGS_opa_data:-}" ]; then
    flags_help
    exit 1
fi

# Generate Terraform Plan
terraform init -lock=false
terraform plan -refresh=false -compact-warnings -lock=false -out=tfplan.out
terraform show -json tfplan.out > tfplan.json

# if the OPA tool prints 'undefined', it is happy...
# It will print a table of errors if it is not happy.
"$OPA_EVAL" \
    --data "$FLAGS_opa_data" \
    --input tfplan.json \
    --fail-defined \
    --format raw \
    "data.vjp.terraform.deny[_]"
