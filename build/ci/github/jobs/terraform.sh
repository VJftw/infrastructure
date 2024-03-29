#!/usr/bin/env bash
# This script generates a JSON list of available Terraform jobs to perform for this repository.
set -Eeuo pipefail

JQ="//third_party/binary:jq"

source "//build/util"
source "//third_party/sh:shflags"

DEFINE_string 'changes_file' 'plz-out/changes' 'path to file with list of Please targets to include. This is skipped if empty/non-existent.' 'c'
DEFINE_string 'out_file' 'plz-out/github/terraform_jobs.json' 'path to file to write the JSON list of Terraform jobs to.' 'o'
DEFINE_string 'includes' '' 'comma separated extra labels to filter terraform jobs by.' 'i'
DEFINE_string 'excludes' '' 'comma separated extra labels to filter terraform jobs by.' 'e'

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

args=(
    "query"
    "alltargets"
    "--plain_output"
)

include="terraform_root"
if [ -n "${FLAGS_includes}" ]; then
    include="${include},${FLAGS_includes}"
fi
args+=("--include" "$include")

if [ -n "${FLAGS_excludes}" ]; then
    # we want excludes to be OR'd so we pass them as unique flags.
    mapfile -t excludes < <(echo -e "${FLAGS_excludes//,/\\n}")
    for exclude in "${excludes[@]}"; do
        args+=("--exclude" "${exclude}")
    done
fi

echo "${args[@]}"
mapfile -t terraform_roots < <(./pleasew "${args[@]}")

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

mkdir -p "$(dirname "${FLAGS_out_file}")"

if [ ${#terraform_roots[@]} -eq 0  ]; then
    echo "[]" | jq -c . > "${FLAGS_out_file}"
else
    jsonified_terraform_roots=$(printf "%s\n" "${terraform_roots[@]}" \
        | "$JQ" -R . \
        | "$JQ" -s .
    )
    printf "%s" "${jsonified_terraform_roots}" | "$JQ" -c . > "${FLAGS_out_file}"
fi

util::success "Wrote ${#terraform_roots[@]} Terraform jobs to ${FLAGS_out_file}"

cat "${FLAGS_out_file}"
