load(
    "@rules_conftest//conftest/private:repositories.bzl",
    _conftest_rules_dependencies = "conftest_rules_dependencies",
)

load(
    "@rules_conftest//conftest/private:toolchain.bzl",
    _conftest_register_toolchains = "conftest_register_toolchains",
)

conftest_rules_dependencies = _conftest_rules_dependencies
conftest_register_toolchains = _conftest_register_toolchains
