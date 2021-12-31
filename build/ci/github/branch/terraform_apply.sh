#!/usr/bin/env bash
# This script will apply Terraform configuration changes to the 'default' workspace.
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

util::info "Running 'terraform plan' for ${please_target}"

./pleasew run -p "$please_target" -- "
terraform init -lock=true -lock-timeout=30s && \
terraform apply -refresh=true -compact-warnings -lock=true -lock-timeout=30s -auto-approve
"