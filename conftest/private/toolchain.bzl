load("@bazel_skylib//lib:paths.bzl", "paths")
load(":platforms.bzl", "OS_ARCH", "BAZEL_ARCH_CONSTRAINTS", "BAZEL_OS_CONSTRAINTS")

def _conftest_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        name = ctx.label.name,
        conftest_binary = ctx.attr.conftest_binary,
    )
    return [toolchain_info]

conftest_toolchain = rule(
    implementation = _conftest_toolchain_impl,
    attrs = {
        "conftest_binary": attr.label(
            mandatory = True,
            cfg = "host",
            executable = True,
            allow_single_file = True,
        ),
    },
)

def conftest_register_toolchains():
    for os, arch in OS_ARCH:
        native.register_toolchains("//conftest/toolchains:conftest_{}_{}_toolchain".format(os, arch))

def _runfiles(ctx, f):
    if ctx.workspace_name:
        path = ctx.workspace_name + "/" + f.short_path
    else:
        path = f.short_path
    return "${RUNFILES_DIR}/%s" % paths.normalize(path)

def _conftest_toolchain_alias(ctx):
    toolchain = ctx.toolchains["//conftest:toolchain"]
    binary = toolchain.conftest_binary
    binary_file = binary.files.to_list()[0]

    script = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.expand_template(
        template = ctx.file._template,
        substitutions = {
            "%{DIR}": ".",
            "%{conftest}": _runfiles(ctx, binary_file),
        },
        output = script,
    )

    return [
        DefaultInfo(
            executable = script,
            runfiles = ctx.runfiles(
                transitive_files = depset(transitive = [
                    binary.files,
                    depset(binary[DefaultInfo].default_runfiles.files),
                    ctx.attr._runfiles_bash.files,
                ]),
            ),
        ),
    ]

conftest_toolchain_alias = rule(
    implementation = _conftest_toolchain_alias,
    executable = True,
    attrs = {
        "version": attr.string(),
        "_template": attr.label(
            default = Label("//conftest/private:conftest.sh.tpl"),
            allow_single_file = True,
        ),
        "_runfiles_bash": attr.label(
            default = Label("@bazel_tools//tools/bash/runfiles"),
        ),
    },
    toolchains = ["//conftest:toolchain"],
)

def declare_toolchains():
    for os, arch in OS_ARCH:
        conftest_toolchain(
            name = "conftest_{}_{}".format(os, arch),
            conftest_binary = Label("@conftest_{}_{}//:conftest".format(os, arch)),
        )

        constraints = (
            BAZEL_OS_CONSTRAINTS[os],
            BAZEL_ARCH_CONSTRAINTS[arch],
        )

        native.toolchain(
            name = "conftest_{}_{}_toolchain".format(os, arch),
            exec_compatible_with = constraints,
            target_compatible_with = constraints,
            toolchain = ":conftest_{}_{}".format(os, arch),
            toolchain_type = "//conftest:toolchain",
        )
