subinclude("//build/defs:sh")

sh_script(
    name = "terraform_workspaces",
    main = "terraform_workspaces.sh",
    deps = ["//third_party/binary:jq"],
)

sh_script(
    name = "terraform_plan",
    main = "terraform_plan.sh",
)

sh_script(
    name = "terraform_apply",
    main = "terraform_apply.sh",
)
