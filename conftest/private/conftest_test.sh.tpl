#!/usr/bin/env bash

OUTPUT="$("%{conftest}" test -o json %{data_files} %{policy_files} %{input_files} %{args} "$@")"
EXIT_CODE="$?"
EXPECTED_EXIT_CODE="%{expected_exit_code}"

echo "$OUTPUT"

if [ $EXIT_CODE -ne $EXPECTED_EXIT_CODE ] ; then
  echo "FAIL (exit code): %s"
  echo "Expected: $EXPECTED_EXIT_CODE"
  echo "Actual: $EXIT_CODE"
  if [ %s = true ]; then
    echo "Output: $OUTPUT"
  fi
  exit 1
fi
