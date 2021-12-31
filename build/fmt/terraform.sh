#!/usr/bin/env bash
set -Eeuo pipefail

source "//build/util"

TERRAFORM="//third_party/terraform:1_1"

util::infor "formatting Terraform files"
mapfile -t tf_dirs < <(./pleasew query alltargets \
    --include terraform_workspace \
    | cut -f1 -d":" \
    | cut -c 3- \
    | sort -u
)

for dir in "${tf_dirs[@]}"; do
    "$TERRAFORM" fmt -write "${dir}" > /dev/null
done

util::rsuccess "formatted Terraform files"
