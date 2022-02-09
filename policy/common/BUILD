subinclude("//build/defs:rego")

rego_bundle(
    name = "common",
    root = "vjp/common",
    srcs = [
        "contains.rego",
        "is_empty.rego",
        "to_set.rego",
    ],
    visibility = ["PUBLIC"],
)

rego_test(
    name = "common_test",
    srcs = [
        "contains_test.rego",
        "is_empty_test.rego",
        "to_set_test.rego",
    ],
    deps = [
        ":common",
    ],
)
