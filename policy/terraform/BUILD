subinclude("///opa//build/defs:opa")

opa_bundle(
    name = "terraform",
    srcs = ["terraform.rego"],
    root = "vjp/terraform",
    visibility = ["PUBLIC"],
    deps = ["//policy/common"],
)

opa_test(
    name = "terraform_test",
    srcs = [
        "terraform_test.rego",
    ],
    deps = [
        ":terraform",
        "//policy/common",
    ],
)

export_file(
    name = "base_data",
    src = "base_data.json",
    visibility = ["PUBLIC"],
)

opa_eval(
    name = "terraform_eval",
    bundles = [
        ":terraform",
        "//policy/common:common",
    ],
    visibility = ["PUBLIC"],
)
