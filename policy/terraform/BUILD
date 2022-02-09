subinclude("//build/defs:rego")

rego_bundle(
    name = "terraform",
    root = "vjp/terraform",
    srcs = ["terraform.rego"],
    deps = ["//policy/common:common"],
    visibility = ["PUBLIC"],
)

rego_test(
    name = "terraform_test",
    srcs = [
        "terraform_test.rego",
    ],
    deps = [
        ":terraform",
        "//policy/common:common",
    ],
)

export_file(
    name = "base_data",
    src = "base_data.json",
    visibility = ["PUBLIC"],
)

opa_eval(
    name = "terraform_eval",
    bundles = [":terraform", "//policy/common:common"],
    query = "data.vjp.terraform.deny[_]",
    visibility = ["PUBLIC"],
)
