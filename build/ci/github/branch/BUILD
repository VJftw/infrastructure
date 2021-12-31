subinclude("//build/defs:sh")

sh_script(
    name = "terraform_apply",
    main = "terraform_apply.sh",
    visibility = ["PUBLIC"],
    deps = [
        "//build/ci/terraform:env",
        "//build/util",
        "//third_party/sh:shflags",
    ],
)
