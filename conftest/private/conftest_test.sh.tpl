#!/usr/bin/env bash

exec "%{conftest}" test -d . -p . %{input_files} %{args}
