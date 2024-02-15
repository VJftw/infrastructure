#!/usr/bin/env bash
# This script generates a list of changed Please targets suitable for testing/building into plz-out.
set -Eeuo pipefail

source "//build/util"
source "//third_party/sh:shflags"

DEFINE_string 'since' '' 'find targets changed since this git reference. If blank, this is best-effort automatically determined' 's'
DEFINE_string 'out_file' 'plz-out/changes' 'path to file to write the list of changes to' 'o'
DEFINE_boolean 'only_prs' false 'only produce a list during pull requests' 'p'

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

# check if we're currently on a branch
current_ref="$(git rev-parse --abbrev-ref HEAD)"
if [ "$current_ref" == "HEAD" ]; then
    current_ref="$(git rev-parse HEAD)"
fi

# ensure we have origin
git fetch --all --depth=100

# automatically determine 'since' if it is blank
if [ -z "${FLAGS_since:-}" ]; then
    if [ -n "${GITHUB_BASE_REF:-}" ]; then
        # If this is set, we're in a Pull Request
        FLAGS_since="origin/${GITHUB_BASE_REF}"
    elif [ "${FLAGS_only_prs}" -eq "${FLAGS_TRUE}" ]; then
        util::success "Skipping as --only_prs is set"
        exit 0
    else
        # Otherwise, use the previous commit.
        FLAGS_since="HEAD~"
    fi
fi

util::info "Finding changed targets between ${FLAGS_since} and ${current_ref}"
mapfile -t changed_targets < <(./pleasew query changes \
    --since "${FLAGS_since}" \
    --level=-1
)

git checkout "${current_ref}" &> /dev/null

mkdir -p "$(dirname "${FLAGS_out_file}")"
printf "%s\n" "${changed_targets[@]}" > "${FLAGS_out_file}"
util::success "Wrote ${#changed_targets[@]} changed Please targets to ${FLAGS_out_file}"

cat "${FLAGS_out_file}"
