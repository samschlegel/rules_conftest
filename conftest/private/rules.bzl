load("@bazel_skylib//lib:shell.bzl", "shell")

def _conftest_test_impl(ctx):
    toolchain = ctx.toolchains["//conftest:toolchain"]
    binary = toolchain.conftest_binary
    binary_file = binary.files.to_list()[0]

    script = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.expand_template(
        template = ctx.file._template,
        substitutions = {
            "%{conftest}": binary_file.short_path,
            "%{data_files}": " ".join(["-d " + f.short_path for f in ctx.files.data]),
            "%{policy_files}": " ".join(["-p " + f.short_path for f in ctx.files.policies]),
            "%{input_files}": " ".join([f.short_path for f in ctx.files.srcs]),
            "%{args}": " ".join([shell.quote(a) for a in ctx.attr.args]),
            "%{expected_exit_code}": str(ctx.attr.expected_exit_code),
        },
        output = script,
    )

    return [
        DefaultInfo(
            executable = script,
            runfiles = ctx.runfiles(
                files = ctx.files.srcs + ctx.files.policies + ctx.files.data,
                transitive_files = depset(transitive = [
                    binary.files,
                    depset(binary[DefaultInfo].default_runfiles.files),
                ]),
            ),
        ),
    ]

conftest_test = rule(
    implementation = _conftest_test_impl,
    test = True,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "policies": attr.label_list(allow_files = True),
        "data": attr.label_list(allow_files = True, default = []),
        "expected_exit_code": attr.int(default = 0),
        "_template": attr.label(
            default = Label("//conftest/private:conftest_test.sh.tpl"),
            allow_single_file = True,
        ),
    },
    toolchains = ["//conftest:toolchain"]
)
