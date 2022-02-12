#!/usr/bin/env bash
# This script configures authentication to the supported `//accounts/...` dependent on the environment.
set -Eeuo pipefail

source "//build/util"
source "//third_party/sh:shflags"

DEFINE_string 'account_tfvars' '' 'the .tfvars file for the account (required)'
DEFINE_string 'default_role' '' 'the role to use by default (required)'
DEFINE_string 'branch_roles' '' 'a mapping of branch names to roles to use, e.g. <branch_name>:<role_name>,<branch_name>:<role_name>'
DEFINE_string 'pull_request_role' '' 'the role to use for pull requests'

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

if [ -z "${FLAGS_account_tfvars:-}" ] \
    || [ -z "${FLAGS_default_role:-}" ]; then
    flags_help
    exit 1
fi

role="${FLAGS_default_role}"

if [ -n "${FLAGS_pull_request_role}" ]; then
    # If there's a role we should use for PRs
    if [ -n "${GITHUB_BASE_REF:-}" ]; then
        # If this is set, we're in a Pull Request
        role="${FLAGS_pull_request_role}"
    fi
elif [ -n "${FLAGS_branch_roles}" ]; then
    # If there's a role we should use for branches
    current_branch="${GITHUB_REF_NAME:-}"
    if [ -n "${current_branch}" ]; then
        branch_role="$(echo "${FLAGS_branch_roles}" \
            | grep -o "${current_branch}:[^,:]*" || true
        )"

        if [ -n "${branch_role}" ]; then
            role="$(echo "${branch_role}" | cut -f2 -d:)"
        else
            util::warn "role not configured for ${current_branch}"
        fi
    fi
fi

account_name="$(grep "^name" "${FLAGS_account_tfvars}" | cut -f2 -d\")"
account_provider="$(basename "$(dirname "${FLAGS_account_tfvars}")")"

util::info "Authenticating as '$role' to '$account_provider/$account_name'"

function auth_aws {
    # Get Account Number for the given Account Alias
    current_profile="${AWS_PROFILE:-default}"
    aws_account_number=$(aws organizations list-accounts --output=text | grep "aws+${account_name}@vjpatel.me" | awk '{ print $4 }')
    role_arn="arn:aws:iam::${aws_account_number}:role/${role}"

    # Write a profile for the alias to assume the role
    aws --profile "$account_name" configure set "role_arn" "$role_arn"
    if [ -v AWS_ACCESS_KEY_ID ]; then
        aws --profile "$account_name" configure set "credential_source " "Environment"
    elif aws configure list-profiles | grep "$current_profile" > /dev/null; then
        # only set the source_profile if it exists
        aws --profile "$account_name" configure set "source_profile" "$current_profile"
    fi


    # Test if we've managed to authenticate successfully
    if ! aws --profile "$account_name" sts get-caller-identity --output=text > /dev/null; then
        util::error "could not authenticate to AWS as '${role_arn}' ($account_name/$role)"
        exit 1
    fi
}

function auth_gcp {
    # Nothing to do as cross-project authorization in GCP doesn't require a new identity.
    return
}

case "$account_provider" in
    "aws")
        auth_aws
    ;;
    "gcp")
        auth_gcp
    ;;
    *)
        util::error "unsupported account provider '$account_provider' for '$FLAGS_account_tfvars'"
        exit 1
    ;;
esac

util::success "Authenticated as '$role' to '$account_provider/$account_name'"
