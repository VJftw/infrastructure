#!/usr/bin/env bash
# This script applies the consolidation of GCP KMS cleanup infrastructure into a 
# single module.
set -Eeuox pipefail

mapfile -t gcp_accounts < \
    <(find accounts/gcp -name '*.tfvars' | cut -f3 -d/ | cut -f1 -d\.)

for account in "${gcp_accounts[@]}"; do
    ./pleasew run "//deployment/accounts/gcp/audit/csp:${account}" -- \
    "terraform init && terraform state rm google_kms_crypto_key.audit_csp google_kms_key_ring.audit_csp google_project_service.cloudkms" \
    || true

    ./pleasew run "//deployment/accounts/gcp/audit/csp:${account}_apply" -- --auto-approve || \
        ./pleasew run "//deployment/accounts/gcp/audit/csp:${account}_apply" -- --auto-approve \
        || ./pleasew run "//deployment/accounts/gcp/audit/csp:${account}_apply" -- --auto-approve
done
