"""Repository macros for conftest"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

load(":platforms.bzl", "OS_ARCH")

CONFTEST_VERSION = "0.23.0"

_BUILD_FILE_CONTENT = """
exports_files(["conftest"])
"""

SHA256S = {
    "conftest_0.23.0_Darwin_x86_64.tar.gz": "863d2eb3f9074c064e5fc0f81946fb7a04325dd72168468c83a99d139337bafc",
    "conftest_0.23.0_Linux_x86_64.tar.gz": "60b9c2f2338514b9ec3185051ff29b3aa83c753901810b3a396789c33fd520de",
    "conftest_0.23.0_Linux_arm64.tar.gz": "852668ffc20bcecbb7ab4862e911b4f35e37d6df1ead89ee1d35901ce03c9e08",
    "conftest_0.23.0_Windows_x86_64.zip": "d7aef1c7a91800a7212eb87d6d3b83a0b931a7b1dc03a346f220a1fd04f4056d",
}

def conftest_rules_dependencies():
    for os, arch in OS_ARCH:
        archive_format = "zip" if os == "windows" else "tar.gz"
        archive_name = "conftest_{v}_{os}_{arch}.{format}".format(
            v = CONFTEST_VERSION,
            os = os.capitalize(),
            arch = arch,
            format = archive_format,
        )

        http_archive(
            name = "conftest_{os}_{arch}".format(os = os, arch = arch),
            sha256 = SHA256S[archive_name],
            urls = [
                "https://github.com/open-policy-agent/conftest/releases/download/v{}/{}".format(CONFTEST_VERSION, archive_name),
            ],
            build_file_content = _BUILD_FILE_CONTENT,
        )
