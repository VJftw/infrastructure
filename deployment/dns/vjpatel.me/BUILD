subinclude("//build/defs:terraform")

terraform_root(
    name = "vjpatel.me",
    srcs = [
        "dns.tf",
        "gcp.tf",
        "gsuite.tf",
        "main.tf",
        "root.tf",
    ],
    modules = [
        "//modules/account/aws:aws",
        "//modules/account/gcp:gcp",
        "//modules/auth/aws:aws",
    ],
)
