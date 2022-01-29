remote_file(
    name = "jq",
    binary = True,
    hashes = [
        "af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44",
    ],
    url = "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64",
    visibility = ["PUBLIC"],
)

SHELLCHECK_VERSION = "v0.8.0"

remote_file(
    name = "shellcheck",
    binary = True,
    exported_files = [f"shellcheck-{SHELLCHECK_VERSION}/shellcheck"],
    extract = True,
    hashes = [
        "ab6ee1b178f014d1b86d1e24da20d1139656c8b0ed34d2867fbb834dad02bf0a",
    ],
    url = f"https://github.com/koalaman/shellcheck/releases/download/{SHELLCHECK_VERSION}/shellcheck-{SHELLCHECK_VERSION}.linux.x86_64.tar.xz",
    visibility = ["PUBLIC"],
)

OPA_VERSION = "v0.36.1"

remote_file(
    name = "opa",
    binary = True,
    hashes = [
        "0bd4a2d07e75a0acad03e4f79b5e8baf43888986ed9147b44bfac753f0504b3d",  # linux_amd64
    ],
    url = f"https://github.com/open-policy-agent/opa/releases/download/{OPA_VERSION}/opa_{CONFIG.OS}_{CONFIG.ARCH}",
    visibility = ["PUBLIC"],
)
