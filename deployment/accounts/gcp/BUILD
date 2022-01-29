genrule(
    name = "accounts_json",
    srcs = ["//accounts/gcp"],
    outs = ["generated_accounts.json"],
    cmd = """
set -Eeuox pipefail
files=($(find accounts/ -type f -name '*.tfvars'))
echo '{}' > $OUTS

for f in "${files[@]}"; do

    $TOOLS \\
        --arg name "$(cat $f | grep 'name' | cut -f2 -d\\")" \\
        --arg environment "$(cat $f | grep 'environment' | cut -f2 -d\\")" \\
        '.[$name] = { environment: $environment }' \\
        $OUTS > ${OUTS}.new
    mv ${OUTS}.new $OUTS

done
    """,
    tools = ["//third_party/binary:jq"],
)

subinclude("//build/defs:terraform")

terraform_root(
    name = "gcp",
    srcs = [
        "accounts.tf",
        "main.tf",
        ":accounts_json",
    ],
    labels = ["accounts"],
    modules = [
        "//modules/account/gcp:gcp",
    ],
)
