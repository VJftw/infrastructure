subinclude("///opa//build/defs:opa")

opa_bundle(
    name = "common",
    srcs = [
        "contains.rego",
        "is_empty.rego",
        "to_set.rego",
    ],
    root = "vjp/common",
    visibility = ["PUBLIC"],
)

opa_test(
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
