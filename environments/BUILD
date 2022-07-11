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

genrule(
    name = "json",
    srcs = [":environments"],
    outs = ["environments.json"],
    cmd = """
set -Eeuox pipefail
files=($(find environments/ -type f -name '*.tfvars'))
echo '{}' > $OUTS

for f in "${files[@]}"; do

    $TOOLS \\
        --arg name "$(cat $f | grep 'name' | cut -f2 -d\\")" \\
        --arg description "$(cat $f | grep 'description' | cut -f2 -d\\")" \\
        '.[$name] = { description: $description }' \\
        $OUTS > ${OUTS}.new
    mv ${OUTS}.new $OUTS

done
    """,
    tools = ["//third_party/binary:jq"],
    visibility = ["PUBLIC"],
)
