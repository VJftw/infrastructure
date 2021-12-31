subinclude("//build/defs:sh")

sh_script(
    name = "terraform",
    main = "terraform.sh",
    visibility = ["PUBLIC"],
    deps = [
        "//build/util",
        "//third_party/binary:jq",
        "//third_party/sh:shflags",
    ],
)
