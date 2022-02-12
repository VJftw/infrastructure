subinclude("//build/defs:account")

filegroup(
    name = "gcp",
    srcs = glob(["**.tfvars"]),
    visibility = ["PUBLIC"],
)

for f in glob(["**.tfvars"]):
    account(f)
