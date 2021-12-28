#!/usr/bin/env bash
set -Eeuo pipefail

source "//build/util"

util::infor "formatting BUILD files"
./pleasew fmt --write
util::rsuccess "formatted BUILD files"
