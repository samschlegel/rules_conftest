#!/usr/bin/env bash

RED='\033[0;31m'
NC='\033[0m' # No Color

OUTPUT="$("%{conftest}" test %{data_files} %{policy_files} %{input_files} %{args} "$@")"
EXIT_CODE="$?"
EXPECTED_EXIT_CODE="%{expected_exit_code}"

printf "conftest output:\n"
printf "$OUTPUT\n"

if [ $EXIT_CODE -ne $EXPECTED_EXIT_CODE ] ; then
  printf "${RED}FAIL (exit code)${NC} - Expected $EXPECTED_EXIT_CODE, got $EXIT_CODE\n"
  exit 1
fi
