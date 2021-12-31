subinclude("//build/defs:sh")

sh_script(
    name = "terraform_plan",
    main = "terraform_plan.sh",
    visibility = ["PUBLIC"],
    deps = [
        "//build/ci/terraform:env",
        "//build/util",
        "//third_party/sh:shflags",
    ],
)
