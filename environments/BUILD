filegroup(
    name = "environments",
    srcs = glob(["**.tfvars"]),
    visibility = ["PUBLIC"],
)

for f in glob(["**.tfvars"]):
    name = basename(f).split(".")[0]

    # _tfvars
    export_file(
        name = f"{name}_tfvars",
        src = f,
        visibility = ["PUBLIC"],
    )
