#!/usr/bin/env bash
# This script will execute Terraform configuration in a Terraform workspace for the given workspace name.
set -Eeuo pipefail

source "//build/util"
source "//third_party/sh:shflags"
source "//build/ci/terraform:env"

DEFINE_string 'workspace_name' '' 'Terraform workspace name (required)' 'w'
DEFINE_string 'please_target' '' 'Please terraform_root target to use (required)' 't'
FLAGS_HELP="USAGE: $0 <apply|destroy> [flags]"

FLAGS "$@" || exit $?
eval set -- "${FLAGS_ARGV}"

ARGS_command="$1"

if [ -z "${ARGS_command}" ] || \
    [ -z "${FLAGS_workspace_name}" ] || \
    [ -z "${FLAGS_please_target}" ]; then
    flags_help
    exit 1
fi

terraform_cmd=""
case "${ARGS_command}" in
    "apply")
        terraform_cmd="terraform apply -refresh=true -compact-warnings -lock=true -lock-timeout=30s -auto-approve"
    ;;
    "destroy")
        terraform_cmd="terraform apply -destroy -refresh=true -compact-warnings -lock=true -lock-timeout=30s -auto-approve && terraform workspace select default"
        if [ "${FLAGS_workspace_name}" != "default" ]; then
            terraform_cmd="${terraform_cmd} && terraform workspace delete ${FLAGS_workspace_name}"
        fi
    ;;
    *)
    flags_help
    exit 1
    ;;
esac

util::info "Running 'terraform ${ARGS_command}' for '${FLAGS_please_target}' on the '${FLAGS_workspace_name}' workspace"

./pleasew run -p "${FLAGS_please_target}" -- "$(cat <<-END
terraform init -lock=true -lock-timeout=30s && \
(terraform workspace list | sed 's/*/ /' | awk '{print \$1}' | grep -w \"^${FLAGS_workspace_name}$\" || terraform workspace new \"${FLAGS_workspace_name}\") && \
terraform workspace select \"${FLAGS_workspace_name}\" && \
${terraform_cmd}
END
)"
