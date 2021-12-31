#!/usr/bin/env bash
# This script defines Terraform specific environment variables, to be sourced in other scripts. 
set -Eeuo pipefail

export TF_IN_AUTOMATION=true
export TF_INPUT=0
