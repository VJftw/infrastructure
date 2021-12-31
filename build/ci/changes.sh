#!/usr/bin/env bash
# This script generates a list of changed Please targets suitable for testing/building into plz-out.
set -Eeuo pipefail

source "//build/util"
source "//third_party/sh:shflags"

DEFINE_string 'since' 'origin/main' 'find targets changed since this git reference' 's'
DEFINE_string 'out_file' 'plz-out/changes' 'path to file to write the list of changes to' 'o'

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

# check if we're currently on a branch
current_ref="$(git rev-parse --abbrev-ref HEAD)"
if [ "$current_ref" == "HEAD" ]; then
    current_ref="$(git rev-parse HEAD)"
fi

# ensure we have origin
git fetch --all --depth=100

changed_targets=($(./pleasew query changes \
    --since "${FLAGS_since}" \
    --level=-1
))

git checkout "${current_ref}" &> /dev/null

mkdir -p "$(dirname "${FLAGS_out_file}")"
printf "%s\n" "${changed_targets[@]}" > "${FLAGS_out_file}"
util::success "Wrote ${#changed_targets[@]} changed Please targets to ${FLAGS_out_file}"
