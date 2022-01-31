subinclude("//build/defs:rego")

rego(
    name = "terraform",
    srcs = ["terraform.rego"],
    visibility = ["PUBLIC"],
)

rego_test(
    name = "terraform_test",
    srcs = ["terraform_test.rego"],
    deps = [":terraform"],
)
