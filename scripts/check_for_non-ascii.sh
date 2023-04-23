#!/bin/sh

################################################################################
# Delete test files files
################################################################################

main()
(
  check_settings

  unset LC_COLLATE

  # Reject patches that introduce non-ASCII characters or hard tabs.
  # Depends on `LC_COLLATE` set at the top of this script.
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
