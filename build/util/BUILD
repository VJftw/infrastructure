subinclude("//build/defs:sh")

sh_script(
    name = "util",
    main = "util.sh",
    visibility = ["PUBLIC"],
    deps = [
        "//third_party/sh:ansi",
    ],
)

sh_cmd(
    name = "_lint_all",
    cmd = "./pleasew run sequential //build/lint/...",
)

sh_cmd(
    name = "_fmt_all",
    cmd = "./pleasew run sequential //build/fmt/...",
)
