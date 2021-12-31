package(default_visibility = ["PUBLIC"])

go_toolchain(
    name = "toolchain",
    hashes = [
        "bd78114b0d441b029c8fe0341f4910370925a4d270a6a590668840675b0c653e",  # linux-amd64
    ],
    version = "1.17.5",
)

go_module(
    name = "x_sys",
    hashes = ["e9ba045ac49a174a9bb1220fc50e89b46e26c8ea18d987248baec06478c9c7bf"],
    install = [
        "unix",
    ],
    module = "golang.org/x/sys",
    version = "95b1ffbd15a57cc5abb3f04402b9e8ec0016a52c",
    licences = ["BSD-3-Clause"],
)

go_module(
    name = "x_text",
    install = [
        "unicode/...",
        "secure/bidirule",
    ],
    module = "golang.org/x/text",
    version = "v0.3.7",
    licences = ["BSD-3-Clause"],
)

go_module(
    name = "x_net",
    install = [
        "http2",
    ],
    module = "golang.org/x/net",
    version = "v0.0.0-20211216030914-fe4d6282115f",
    licences = ["BSD-3-Clause"],
    deps = [
        ":x_text",
    ]
)


go_module(
    name = "jessevdk_flags",
    licences = ["BSD-3-Clause"],
    module = "github.com/jessevdk/go-flags",
    version = "v1.5.0",
    deps = [":x_sys"],
)

go_module(
    name = "rs_zerolog",
    install = [
        ".",
        "internal/json",
    ],
    licences = ["MIT"],
    module = "github.com/rs/zerolog",
    version = "v1.23.0",
)

go_module(
    name = "ini_ini",
    module = "github.com/go-ini/ini",
    version = "v1.66.2",
    licences = ["Apache-2.0"],
)

go_module(
    module = "github.com/jmespath/go-jmespath",
    name = "jmespath_jmespath",
    version = "v0.4.0",
    licences = ["Apache-2.0"],
)

go_module(
    name = "aws_aws-sdk",
    module = "github.com/aws/aws-sdk-go",
    install = [
        "aws/...",
        "client",
        "internal/...",
        "private/...",
        "service/sso/...",
        "service/sts/...",
        "service/organizations",
    ],
    version = "v1.42.25",
    licences = ["Apache-2.0"],
    deps = [
        ":jmespath_jmespath",
        ":x_net",
    ]
)
