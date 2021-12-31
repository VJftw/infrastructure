#!/usr/bin/env bash

set -Eeuo pipefail

if [ -z "$1" ]; then
    printf "Please provide a Please target.\n"
fi

please_target="$1"

export TF_IN_AUTOMATION=true
export TF_INPUT=0

./pleasew run -p "$please_target" -- "
terraform init -lock=true -lock-timeout=30s && \
terraform apply -refresh=true -compact-warnings -lock=true -lock-timeout=30s -auto-approve
"
