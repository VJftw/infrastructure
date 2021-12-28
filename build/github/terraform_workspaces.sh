#!/usr/bin/env bash

set -Eeuo pipefail

JQ="$(dirname $0)/third_party/binary/jq-linux64"

./pleasew query alltargets --include terraform_workspace --plain_output \
    | "$JQ" -R . \
    | "$JQ" -s .

if [ ! -z "$1" ]; then
    mkdir -p "$(dirname "$1")"
    ./pleasew query alltargets --include terraform_workspace --plain_output \
    | "$JQ" -R . \
    | "$JQ" -s . > "$1"
    printf "Wrote to '%s'.\n" "$1"
fi
