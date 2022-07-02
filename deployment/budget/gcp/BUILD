subinclude("//build/defs:terraform")

terraform_root(
    name = "gcp",
    srcs = [
        "main.tf",
    ],
)

# re-import
"""
$ plz run //deployment/budget/gcp:gcp -- bash
terraform init
terraform import "google_billing_budget.budget" "billingAccounts/010D49-D87462-600CCF/budgets/Default"
"""
