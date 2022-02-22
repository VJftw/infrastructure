#!/usr/bin/env bash
# This script will plan Terraform configuration changes to the 'default' workspace.
set -Eeuo pipefail

source "//build/util"
source "//third_party/sh:shflags"

DEFINE_string 'please_target' '' 'Please terraform_root target to use (required)' 't'

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

if [ -z "${FLAGS_please_target}" ]; then
    flags_help
    exit 1
fi

per_tf_root_opa_data_target="${FLAGS_please_target//\:/\:_}#opa_data"
./pleasew build -p "$per_tf_root_opa_data_target"
PER_TF_ROOT_OPA_DATA="$(./pleasew query output "$per_tf_root_opa_data_target")"

util::info "Running 'terraform plan' for ${FLAGS_please_target}"

./pleasew run -p "$FLAGS_please_target" -- ":_terraform_plan_cmds" --opa_data="$PER_TF_ROOT_OPA_DATA"

util::success "Terraform plan for ${FLAGS_please_target} is OK!"
