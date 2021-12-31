#!/usr/bin/env bash
# This script stores AWS credentials from the environment into the 
# [default] profile of an AWS credentials file in order to support 
# cross-account AWS identities via assume_role.
# This is needed as the official https://github.com/aws-actions/configure-aws-credentials 
# GitHub Action only supports setting AWS credentials via environment variables which takes precedent
# and doesn't support the use of AWS profiles to assume different roles

# set AWS SHARED CREDENTIALS FILE
script_path="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
# shellcheck disable=SC2001
repo_path="$( echo "$script_path" | sed 's#/plz-out.*$##' )"
export AWS_SHARED_CREDENTIALS_FILE="${repo_path}/plz-out/aws/credentials"

mkdir -p "$(dirname ${AWS_SHARED_CREDENTIALS_FILE})"
touch "$AWS_SHARED_CREDENTIALS_FILE"
chmod 600 "$AWS_SHARED_CREDENTIALS_FILE"

if [ "${AWS_ACCESS_KEY_ID:-}" != "" ]; then
    echo "[default]" > "$AWS_SHARED_CREDENTIALS_FILE"
    echo "aws_access_key_id = \"${AWS_ACCESS_KEY_ID}\"" >> "$AWS_SHARED_CREDENTIALS_FILE"
    echo "aws_secret_access_key = \"${AWS_SECRET_ACCESS_KEY}\"" >> "$AWS_SHARED_CREDENTIALS_FILE"
fi

if [ "${AWS_SESSION_TOKEN:-}" != "" ]; then
    echo "aws_session_token = \"${AWS_SESSION_TOKEN}\"" >> "$AWS_SHARED_CREDENTIALS_FILE"
fi

cat <<EOF
export AWS_SHARED_CREDENTIALS_FILE="${AWS_SHARED_CREDENTIALS_FILE}"
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
EOF
