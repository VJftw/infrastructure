#!/usr/bin/env bash
# This script generates a JSON list of available Terraform jobs to perform for this repository.
set -Eeuo pipefail

JQ="//third_party/binary:jq"

source "//build/util"
source "//third_party/sh:shflags"

DEFINE_string 'changes_file' 'plz-out/changes' 'path to file with list of Please targets to include. This is skipped if empty/non-existent.' 'c'
DEFINE_string 'out_file' 'plz-out/github/terraform_jobs.json' 'path to file to write the JSON list of Terraform jobs to.' 'o'

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

mapfile -t terraform_roots < <(./pleasew query alltargets \
    --include terraform_workspace \
    --plain_output
)

# Filter terraform_roots to just changed targets if changes_file is non-empty.
if [ -f "${FLAGS_changes_file}" ]; then
    mapfile -t changes < "${FLAGS_changes_file}"
    if [ ${#changes[@]} -ne 0 ]; then
        new_terraform_roots=()
        for terraform_root in "${terraform_roots[@]}"; do
            if util::contains "$terraform_root" "${changes[@]}"; then
                new_terraform_roots+=("$terraform_root")
            fi
        done
        terraform_roots=("${new_terraform_roots[@]}")
    fi
fi

jsonified_terraform_roots=$(printf "%s\n" "${terraform_roots[@]}" \
    | "$JQ" -R . \
    | "$JQ" -s .
)

mkdir -p "$(dirname "${FLAGS_out_file}")"
printf "%s" "${jsonified_terraform_roots}" | "$JQ" -c . > "${FLAGS_out_file}"
util::success "Wrote ${#terraform_roots[@]} Terraform jobs to ${FLAGS_out_file}"
