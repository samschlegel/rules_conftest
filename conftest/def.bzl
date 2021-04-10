load("//conftest/private:toolchain.bzl", "conftest_toolchain_alias")

def conftest(name):
    conftest_toolchain_alias(
        name = name,
        visibility = ["//visibility:public"],
    )
