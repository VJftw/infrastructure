#!/usr/bin/env bash

set -Eeuo pipefail

JQ="//third_party/binary:jq"

./pleasew query alltargets --include terraform_workspace --plain_output \
    | "$JQ" -R . \
    | "$JQ" -s .

outfile="${1:-}"

if [ ! -z "${outfile}" ]; then
    mkdir -p "$(dirname "$1")"
    ./pleasew query alltargets --include terraform_workspace --plain_output \
    | "$JQ" -R . \
    | "$JQ" -scj . > "$1"
    printf "Wrote to '%s'.\n" "$1"
fi
