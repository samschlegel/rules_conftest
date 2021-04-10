BAZEL_OS_CONSTRAINTS = {
    "linux": "@platforms//os:linux",
    "darwin": "@platforms//os:osx",
    "windows": "@platforms//os:windows",
}

BAZEL_ARCH_CONSTRAINTS = {
    "x86_64": "@platforms//cpu:x86_64",
    "arm64": "@platforms//cpu:aarch64",
}

OS_ARCH = (
    ("darwin", "x86_64"),
    ("linux", "x86_64"),
    ("linux", "arm64"),
    ("windows", "x86_64"),
)
