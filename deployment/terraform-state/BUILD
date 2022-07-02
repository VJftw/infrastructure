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
        "//accounts/gcp:vjp-terraform-state_tfvars",
    ],
)

# re-import
"""
$ plz run //deployment/terraform-state:terraform-state -- bash
terraform init
terraform import module.terraform_remote_state.module.kms.google_kms_key_ring.this projects/vjp-terraform-state/locations/europe-west2/keyRings/vjp-terraform-state-terraform-state-bucket
terraform import module.terraform_remote_state.google_kms_crypto_key_iam_binding.binding "vjp-terraform-state/europe-west2/vjp-terraform-state-terraform-state-bucket/vjp-terraform-state-terraform-state-bucket roles/cloudkms.cryptoKeyEncrypterDecrypter"
terraform import module.terraform_remote_state.google_storage_bucket.terraform_state "vjp-terraform-state"
terraform import module.terraform_remote_state.module.kms.google_cloud_scheduler_job.function_trigger "europe-west1/fn-dc8be1e-cron"
terraform import module.terraform_remote_state.module.kms.google_cloudfunctions_function.function "vjp-terraform-state/europe-west2/fn-dc8be1e"
terraform import module.terraform_remote_state.module.kms.google_kms_crypto_key.this "projects/vjp-terraform-state/locations/europe-west2/keyRings/vjp-terraform-state-terraform-state-bucket/cryptoKeys/vjp-terraform-state-terraform-state-bucket"
terraform import module.terraform_remote_state.module.kms.google_kms_crypto_key_iam_binding.this "vjp-terraform-state/europe-west2/vjp-terraform-state-terraform-state-bucket/vjp-terraform-state-terraform-state-bucket roles/cloudkms.admin"
terraform import module.terraform_remote_state.module.kms.google_project_service.cloudbuild""vjp-terraform-state/cloudbuild.googleapis.com"
terraform import module.terraform_remote_state.module.kms.google_project_service.cloudfunctions" "vjp-terraform-state/cloudfunctions.googleapis.com"
terraform import module.terraform_remote_state.module.kms.google_project_service.cloudkms" "vjp-terraform-state/cloudkms.googleapis.com"
terraform import module.terraform_remote_state.module.kms.google_project_service.cloudscheduler" "vjp-terraform-state/cloudscheduler.googleapis.com"
terraform import module.terraform_remote_state.module.kms.google_pubsub_topic.function_trigger" "fn-dc8be1e-trigger"
terraform import module.terraform_remote_state.module.kms.google_service_account.function" "projects/vjp-terraform-state/serviceAccounts/fn-dc8be1e@vjp-terraform-state.iam.gserviceaccount.com"
terraform import module.terraform_remote_state.module.kms.google_storage_bucket.function" "fn-dc8be1e"
"""
