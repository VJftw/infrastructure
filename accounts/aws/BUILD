subinclude("//build/defs:account")

filegroup(
    name = "aws",
    srcs = glob(["**.tfvars"]),
    visibility = ["PUBLIC"],
)

for f in glob(["**.tfvars"]):
    account(f)

genrule(
    name = "starlark",
    srcs = [":aws"],
    outs = ["accounts.starlark"],
    cmd = """
set -Eeuox pipefail
files=($(find accounts/ -type f -name '*.tfvars'))
echo '[]' > $OUTS

for f in "${files[@]}"; do

    $TOOLS \\
        --arg name "$(cat $f | grep 'name' | cut -f2 -d\\")" \\
        --arg environment "$(cat $f | grep 'environment' | cut -f2 -d\\")" \\
        '. += [{ "name": $name, "environment": $environment }]' \\
        $OUTS > ${OUTS}.new
    mv ${OUTS}.new $OUTS

done

sed -i '1s/^/accounts = /' $OUTS
    """,
    tools = ["//third_party/binary:jq"],
    visibility = ["PUBLIC"],
)
