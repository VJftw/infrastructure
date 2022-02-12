subinclude("//build/defs:sh")

sh_script(
    name = "auth_tool",
    main = "auth_tool.sh",
    visibility = ["//accounts/..."],
    deps = [
        "//build/util",
        "//third_party/sh:shflags",
    ],
)
