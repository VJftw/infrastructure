#!/usr/bin/env bash
set -Eeuo pipefail

source "//build/util"

OPA="//third_party/binary:opa"

util::infor "checking Rego files"
mapfile -t rego_dirs < <(./pleasew query alltargets \
    --include rego \
    | cut -f1 -d":" \
    | cut -c 3- \
    | sort -u
)

for dir in "${rego_dirs[@]}"; do
    if ! "$OPA" fmt --fail "${dir}" &> /dev/null; then
        util::rerror "rego files incorrectly formatted. Please run:
        $ ./pleasew run //scripts/fmt:rego"
        exit 1
    fi
done

util::rsuccess "checked rego files"
