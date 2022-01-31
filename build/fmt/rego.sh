#!/usr/bin/env bash
set -Eeuo pipefail

source "//build/util"

OPA="//third_party/binary:opa"

util::infor "formatting rego files"
mapfile -t rego_dirs < <(./pleasew query alltargets \
    --include rego \
    | cut -f1 -d":" \
    | cut -c 3- \
    | sort -u
)

for dir in "${rego_dirs[@]}"; do
    "$OPA" fmt --write "${dir}" > /dev/null
done

util::rsuccess "formatted rego files"
