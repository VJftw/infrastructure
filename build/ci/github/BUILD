subinclude("//build/defs:sh")

sh_script(
    name = "terraform_workspace",
    main = "terraform_workspace.sh",
    visibility = ["PUBLIC"],
    deps = [
        "//build/ci/terraform:env",
        "//build/util",
        "//third_party/sh:shflags",
    ],
)
