subinclude("//build/defs:rego")

rego_bundle(
    name = "terraform",
    srcs = ["terraform.rego"],
    visibility = ["PUBLIC"],
)

rego_test(
    name = "terraform_test",
    srcs = ["terraform_test.rego"],
    deps = [":terraform"],
)

export_file(
    name = "base_data",
    src = "base_data.json",
    visibility = ["PUBLIC"],
)
