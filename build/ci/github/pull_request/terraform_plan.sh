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

util::info "Running 'terraform plan' for ${FLAGS_please_target}"

./pleasew run -p "$FLAGS_please_target" -- "
terraform init -lock=false && \
terraform plan -refresh=true -compact-warnings -lock=false
"
