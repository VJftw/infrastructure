# TERRAFORM_DEF_VERSION="v0.0.1"
# TERRAFORM_TOOL="//third_party/defs:terraform_tool"
# TERRAFORM_DEFAULT_TOOLCHAIN="//third_party/terraform:1_1"

# remote_file(
#     name = "_terraform#download",
#     url = f"https://raw.githubusercontent.com/VJftw/please-terraform/{TERRAFORM_DEF_VERSION}/build/defs/terraform.build_defs",
#     hashes = ["c7b3d51c8190c8d675708642dc3915096f07ce0ac331818642a1d9584ffbdd19"],
# )

# remote_file(
#     name = "terraform_tool",
#     url = f"https://github.com/VJftw/please-terraform/releases/download/{TERRAFORM_DEF_VERSION}/please_terraform",
#     visibility = ["PUBLIC"],
#     binary = True,
# )

# genrule(
#     name = "terraform",
#     srcs = [":_terraform#download"],
#     outs = ["terraform_custom.build_defs"],
#     cmd = [
#         "mv $SRCS $OUTS",
#         # Replace CONFIG.TERRAFORM.TOOL with your tool.
#         f"sed -i 's#CONFIG.TERRAFORM.TOOL#\"{TERRAFORM_TOOL}\"#g' $OUTS",
#         # Replace CONFIG.TERRAFORM.DEFAULT_TOOLCHAIN with your tool.
#         f"sed -i 's#CONFIG.TERRAFORM.DEFAULT_TOOLCHAIN#\"{TERRAFORM_DEFAULT_TOOLCHAIN}\"#g' $OUTS",
#     ],
#     visibility = ["PUBLIC"],
# )
