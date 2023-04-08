#!/bin/sh

################################################################################

execution_dir=".."

################################################################################
# Delete test files files
################################################################################

check_settings()
{
  if [ -z "${execution_dir}" ]; then
    echo "Error: 'execution_dir' is invalid..." >&2
    exit 1
  fi
}

################################################################################

main()
(
  check_settings

  # Print commands while executing
  # set -x

  # { ch "${execution_dir}/"; } || exit 1

  unset LC_COLLATE

  # Reject patches that introduce non-ASCII characters or hard tabs.
  # Depends on LC_COLLATE set at the top of this script.
  grep -rn '[^ -~]' libcxx/include libcxx/src libcxx/test libcxx/benchmarks \
        --exclude '*.dat' \
        --exclude 'escaped_output.*.pass.cpp' \
        --exclude 'format_tests.h' \
        --exclude 'format.functions.tests.h' \
        --exclude 'formatter.*.pass.cpp' \
        --exclude 'grep.pass.cpp' \
        --exclude 'locale-specific_form.pass.cpp' \
        --exclude 'ostream.pass.cpp' \
        --exclude 'std_format_spec_string_unicode.bench.cpp' \
        --exclude 'underflow.pass.cpp' \
)

################################################################################

main "$@"
