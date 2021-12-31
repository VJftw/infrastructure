#!/usr/bin/env bash

set -Eeuo pipefail

if [ -z "$1" ]; then
    printf "Please provide a Please target.\n"
fi

please_target="$1"

export TF_IN_AUTOMATION=true
export TF_INPUT=0
export AWS_SHARED_CREDENTIALS_FILE="plz-out/aws/credentials"

./pleasew run -p "${please_target}_extended" -- "
terraform init -lock=false && \
terraform plan -refresh=true -compact-warnings -lock=false
"
