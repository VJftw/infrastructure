subinclude("//build/defs:sh")

sh_script(
    name = "_terraform_plan_cmds",
    main = "_terraform_plan_cmds.sh",
    deps = [
        "//build/ci/terraform:env",
        "//build/util",
        "//policy/terraform:terraform_eval",
        "//third_party/sh:shflags",
    ],
)

sh_script(
    name = "terraform_plan",
    main = "terraform_plan.sh",
    visibility = ["PUBLIC"],
    deps = [
        ":_terraform_plan_cmds",
        "//build/util",
        "//third_party/sh:shflags",
    ],
)
