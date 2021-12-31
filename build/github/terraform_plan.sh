#!/usr/bin/env bash

set -Eeuo pipefail

if [ -z "$1" ]; then
    printf "Please provide a Please target.\n"
fi

please_target="$1"

export TF_IN_AUTOMATION=true
export TF_INPUT=0

# set AWS SHARED CREDENTIALS FILE
# script_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# # shellcheck disable=SC2001
# repo_path="$( echo "$script_path" | sed 's#/plz-out.*$##' )"
# export AWS_SHARED_CREDENTIALS_FILE="${repo_path}/plz-out/aws/credentials"
# mkdir -p "$(dirname ${AWS_SHARED_CREDENTIALS_FILE})"
# if [ "${AWS_ACCESS_KEY_ID:-}" != "" ]; then
#     echo "[default]" > "$AWS_SHARED_CREDENTIALS_FILE"
#     echo "aws_access_key_id = \"${AWS_ACCESS_KEY_ID}\"" >> "$AWS_SHARED_CREDENTIALS_FILE"
#     echo "aws_secret_access_key = \"${AWS_SECRET_ACCESS_KEY}\"" >> "$AWS_SHARED_CREDENTIALS_FILE"
#     unset AWS_ACCESS_KEY_ID
#     unset AWS_SECRET_ACCESS_KEY
# fi

# if [ "${AWS_SESSION_TOKEN:-}" != "" ]; then
#     echo "aws_session_token = \"${AWS_SESSION_TOKEN}\"" >> "$AWS_SHARED_CREDENTIALS_FILE"
#     unset AWS_SESSION_TOKEN
# fi

./pleasew run -p "${please_target}_extended" -- "
terraform init -lock=false && \
terraform plan -refresh=true -compact-warnings -lock=false
"
