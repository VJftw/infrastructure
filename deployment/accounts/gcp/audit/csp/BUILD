subinclude("//build/defs:terraform")

terraform_per_account(
    srcs = [
        "bucket.tf",
        "main.tf",
        "sink.tf",
        "variables.tf",
    ],
    account_auths = {
        "//accounts/gcp:vjp-logs_auth": {
            "branches": {
                "main": "administrator",
            },
            "pull_request": "reader",
        },
    },
    modules = [
        "//modules/kms/gcp:gcp",
    ],
    per_account_roles = {
        "branches": {
            "main": "administrator",
        },
        "pull_request": "reader",
    },
    provider = "gcp",
)

# re-import
"""
plz query alltargets --include terraform_workspace //deployment/accounts/gcp/audit/csp/... \
    | while read target ; do \
        echo "$target" \
        && export name="$(echo "$target" | cut -f2 -d:)" \
        && plz run "$target" -- "$(cat <<'EOF'
terraform init
export fn_id="fn-$(echo -n "$name-csp-audit-kms-key-cleaner" | sha1sum - | cut -c1-7)"
set +e
terraform import google_kms_crypto_key_iam_binding.binding "vjp-logs/europe-west1/${name}-csp-audit/${name}-csp-audit roles/cloudkms.cryptoKeyEncrypterDecrypter"
terraform import google_logging_project_sink.audit_csp "projects/$name/sinks/audit-csp"
terraform import google_project_service.logging "$name/logging.googleapis.com"
terraform import google_storage_bucket_iam_binding.binding "b/${name}-audit-csp roles/storage.objectCreator"
terraform import google_storage_bucket.audit_csp "${name}-audit-csp"
terraform import module.kms.google_cloud_scheduler_job.function_trigger "projects/vjp-logs/locations/europe-west1/jobs/${fn_id}-cron"
terraform import module.kms.google_cloudfunctions_function.function "vjp-logs/europe-west1/${fn_id}"
terraform import module.kms.google_kms_crypto_key.this "projects/vjp-logs/locations/europe-west1/keyRings/${name}-csp-audit/cryptoKeys/${name}-csp-audit"
terraform import module.kms.google_kms_crypto_key_iam_binding.this "vjp-logs/europe-west1/${name}-csp-audit/${name}-csp-audit roles/cloudkms.admin"
terraform import module.kms.google_kms_key_ring.this "projects/vjp-logs/locations/europe-west1/keyRings/${name}-csp-audit"
terraform import module.kms.google_project_service.cloudbuild "vjp-logs/cloudbuild.googleapis.com"
terraform import module.kms.google_project_service.cloudfunctions "vjp-logs/cloudfunctions.googleapis.com"
terraform import module.kms.google_project_service.cloudkms "vjp-logs/cloudkms.googleapis.com"
terraform import module.kms.google_project_service.cloudscheduler "vjp-logs/cloudscheduler.googleapis.com"
terraform import module.kms.google_pubsub_topic.function_trigger "projects/vjp-logs/topics/${fn_id}-trigger"
terraform import module.kms.google_service_account.function "projects/vjp-logs/serviceAccounts/${fn_id}@vjp-logs.iam.gserviceaccount.com"
terraform import module.kms.google_storage_bucket.function "$fn_id"
set -e
EOF
)" \
    ; done
"""
