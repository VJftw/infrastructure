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
        "//third_party/terraform:1_1",
    ],
)

sh_script(
    name = "sh",
    main = "sh.sh",
    visibility = ["PUBLIC"],
    deps = [
        "//build/util",
        "//third_party/binary:shellcheck",
    ],
)
