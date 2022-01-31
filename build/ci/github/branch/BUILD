subinclude("//build/defs:sh")

sh_script(
    name = "terraform_apply",
    main = "terraform_apply.sh",
    visibility = ["PUBLIC"],
    deps = [
        "//build/ci/terraform:env",
        "//build/util",
        "//policy/terraform",
        "//third_party/binary:opa",
        "//third_party/sh:shflags",
    ],
)

sh_script(
    name = "manage_accounts",
    main = "manage_accounts.sh",
    visibility = ["PUBLIC"],
    deps = [
        "//build/ci/terraform:env",
        "//build/util",
        "//third_party/sh:shflags",
    ],
)
