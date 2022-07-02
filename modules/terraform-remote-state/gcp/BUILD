subinclude("//build/defs:terraform")

terraform_module(
    name = "gcp",
    srcs = [
        "bucket.tf",
        "main.py",
        "main.tf",
        "re-encrypter.tf",
        "requirements.txt",
        "variables.tf",
    ],
    visibility = ["PUBLIC"],
    deps = [
        "//modules/kms/gcp",
    ],
)
