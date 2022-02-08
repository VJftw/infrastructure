subinclude("//build/defs:sh")

sh_script(
    name = "terraform_plan",
    main = "terraform_plan.sh",
    visibility = ["PUBLIC"],
    deps = [
        "//build/ci/terraform:env",
        "//build/util",
        "//policy/terraform",
        "//policy/terraform:base_data",
        "//third_party/binary:opa",
        "//third_party/binary:jq",
        "//third_party/sh:shflags",
    ],
)
