subinclude("//build/defs:sh")

sh_script(
    name = "_terraform_apply_cmds",
    main = "_terraform_apply_cmds.sh",
    deps = [
        "//build/ci/terraform:env",
        "//build/util",
        "//policy/terraform:terraform_eval",
        "//third_party/sh:shflags",
    ],
)

sh_script(
    name = "terraform_apply",
    main = "terraform_apply.sh",
    visibility = ["PUBLIC"],
    deps = [
        ":_terraform_apply_cmds",
        "//build/util",
        "//third_party/sh:shflags",
    ],
)
