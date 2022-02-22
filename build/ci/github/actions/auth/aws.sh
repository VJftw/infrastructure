#!/usr/bin/env bash
# This script translates AWS credentials from environment 
# variables as provided by the GitHub action into an AWS shared configuration
# file so that profiles can be used.

source "//build/util"

if [ -v AWS_ACCESS_KEY_ID ]; then
    aws --profile "default" configure set "aws_access_key_id" "$AWS_ACCESS_KEY_ID"
    util::info "set aws_access_key_id for 'default'"
fi
if [ -v AWS_SECRET_ACCESS_KEY ]; then
    aws --profile "default" configure set "aws_secret_access_key" "$AWS_SECRET_ACCESS_KEY"
    util::info "set aws_secret_access_key for 'default'"
fi
if [ -v AWS_SESSION_TOKEN ]; then
    aws --profile "default" configure set "aws_session_token" "$AWS_SESSION_TOKEN"
    util::info "set aws_session_token for 'default'"
fi

# remove all AWS_ environment variables
sed -i '/^AWS_/d' "$GITHUB_ENV"
