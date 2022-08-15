subinclude("//build/defs:sh")

sh_script(
    name = "please",
    main = "please.sh",
    visibility = ["PUBLIC"],
    deps = [
        "//build/util",
    ],
)

sh_script(
    name = "terraform",
    main = "terraform.sh",
    visibility = ["PUBLIC"],
    deps = [
        "//build/util",
        "//third_party/terraform:1.1",
    ],
)

sh_script(
    name = "rego",
    main = "rego.sh",
    visibility = ["PUBLIC"],
    deps = [
        "//build/util",
        "//third_party/binary:opa",
    ],
)
