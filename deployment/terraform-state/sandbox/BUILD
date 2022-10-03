subinclude("//build/defs:terraform")

terraform_root(
    name = "terraform-state",
    srcs = [
        "main.tf",
        "variables.tf",
    ],
    modules = [
        "//modules/terraform-remote-state/gcp:gcp",
    ],
    var_files = [
        "//accounts/gcp:vjp-sandbox-terraform-state_tfvars",
    ],
)

# re-import
"""
$ plz run //deployment/terraform-state/sandbox:terraform-state -- bash
terraform init
terraform import module.terraform_remote_state.module.kms.google_kms_key_ring.this "projects/vjp-sandbox-terraform-state/locations/europe-west2/keyRings/vjp-sandbox-terraform-state-terraform-state-bucket"
terraform import module.terraform_remote_state.google_kms_crypto_key_iam_binding.binding "vjp-sandbox-terraform-state/europe-west2/vjp-sandbox-terraform-state-terraform-state-bucket/vjp-sandbox-terraform-state-terraform-state-bucket roles/cloudkms.cryptoKeyEncrypterDecrypter"
terraform import module.terraform_remote_state.google_storage_bucket.terraform_state "vjp-sandbox-terraform-state"
terraform import module.terraform_remote_state.module.kms.google_cloud_scheduler_job.function_trigger "europe-west1/fn-2f79615-cron"
terraform import module.terraform_remote_state.module.kms.google_cloudfunctions_function.function "vjp-sandbox-terraform-state/europe-west2/fn-2f79615"
terraform import module.terraform_remote_state.module.kms.google_kms_crypto_key.this "projects/vjp-sandbox-terraform-state/locations/europe-west2/keyRings/vjp-sandbox-terraform-state-terraform-state-bucket/cryptoKeys/vjp-sandbox-terraform-state-terraform-state-bucket"
terraform import module.terraform_remote_state.module.kms.google_kms_crypto_key_iam_binding.this "vjp-sandbox-terraform-state/europe-west2/vjp-sandbox-terraform-state-terraform-state-bucket/vjp-sandbox-terraform-state-terraform-state-bucket roles/cloudkms.admin"
terraform import module.terraform_remote_state.module.kms.google_project_service.cloudbuild "vjp-sandbox-terraform-state/cloudbuild.googleapis.com"
terraform import module.terraform_remote_state.module.kms.google_project_service.cloudfunctions "vjp-sandbox-terraform-state/cloudfunctions.googleapis.com"
terraform import module.terraform_remote_state.module.kms.google_project_service.cloudkms "vjp-sandbox-terraform-state/cloudkms.googleapis.com"
terraform import module.terraform_remote_state.module.kms.google_project_service.cloudscheduler "vjp-sandbox-terraform-state/cloudscheduler.googleapis.com"
terraform import module.terraform_remote_state.module.kms.google_pubsub_topic.function_trigger "fn-2f79615-trigger"
terraform import module.terraform_remote_state.module.kms.google_service_account.function "projects/vjp-sandbox-terraform-state/serviceAccounts/fn-2f79615@vjp-sandbox-terraform-state.iam.gserviceaccount.com"
terraform import module.terraform_remote_state.module.kms.google_storage_bucket.function "fn-2f79615"
"""
