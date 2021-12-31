#!/usr/bin/env bash
set -Eeuo pipefail

source "//build/util"

TERRAFORM="//third_party/terraform:1_1"

util::infor "checking Terraform files"
mapfile -t tf_dirs < <(./pleasew query alltargets \
    --include terraform_workspace \
    | cut -f1 -d":" \
    | cut -c 3- \
    | sort -u
)

for dir in "${tf_dirs[@]}"; do
    if ! "$TERRAFORM" fmt -check "${dir}" > /dev/null; then
        util::rerror "BUILD files incorrectly formatted. Please run:
        $ ./pleasew run //scripts/fmt:terraform"
        exit 1
    fi
done

util::rsuccess "checked Terraform files"
