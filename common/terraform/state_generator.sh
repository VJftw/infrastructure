#!/usr/bin/env bash
# This script dynamically generates a Terraform remote state configuration with the given inputs.
set -Eeuo pipefail

source "//build/util"
source "//third_party/sh:shflags"

DEFINE_string 'out_file' '' 'the path to write the generate terraform remote state configuration to (required)'
DEFINE_string 'package' '' 'the package of the please target (required)'
DEFINE_string 'name' 'plz-out/changes' 'the name of the please target (required)'
DEFINE_string 'default_state_bucket' '' 'the bucket to use for terraform state by default (required)'
DEFINE_string 'branch_state_buckets' '' 'a mapping of branch names to buckets to use for terraform state'
DEFINE_string 'pull_request_state_bucket' '' 'the bucket to use for terraform state in pull requests'

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

if [ -z "${FLAGS_out_file:-}" ] \
    || [ -z "${FLAGS_package:-}" ] \
    || [ -z "${FLAGS_name:-}" ] \
    || [ -z "${FLAGS_default_state_bucket:-}" ]; then
    flags_help
    exit 1
fi

remote_state_bucket="${FLAGS_default_state_bucket}"

if [ -n "${FLAGS_pull_request_state_bucket}" ]; then
    # If there's a bucket we should use for PRs
    if [ -n "${GITHUB_BASE_REF:-}" ]; then
        # If this is set, we're in a Pull Request
        remote_state_bucket="${FLAGS_pull_request_state_bucket}"
    fi
elif [ -n "${FLAGS_branch_state_buckets}" ]; then
    # If there's a bucket we should use for branches
    current_branch="${GITHUB_REF_NAME:-}"
    if [ -n "${current_branch}" ]; then
        branch_bucket="$(echo "${FLAGS_branch_state_buckets}" \
            | grep -o "${current_branch}:[^,:]*" || true
        )"

        if [ -n "${branch_bucket}" ]; then
            remote_state_bucket="$(echo "${branch_bucket}" | cut -f2 -d:)"
        else
            util::warn "bucket not configured for ${current_branch}"
        fi
    fi
fi

repo_address="$(git config --get remote.origin.url \
    | sed 's#:#/#' \
    | sed 's#git@##' \
    | sed 's#\.git##' \
    | rev | cut -f-3 -d/ | rev
)"

prefix="${repo_address}/${FLAGS_package}/${FLAGS_name}"

cat <<EOF > "${FLAGS_out_file}"
terraform {
    backend "gcs" {
        bucket  = "${remote_state_bucket}"
        prefix  = "${prefix}"
    }
}
EOF

util::success "Generated Terraform remote state configuration to 'gs://${remote_state_bucket}' with prefix '${prefix}'"
