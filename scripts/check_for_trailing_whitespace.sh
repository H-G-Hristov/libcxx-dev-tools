#!/bin/sh

################################################################################
# Find files with trailing whitespace
################################################################################

main()
(
  check_settings

  # Find code with trailing whitespace
  grep -rn '[[:blank:]]$' libcxx/include libcxx/src libcxx/test libcxx/benchmarks
)

################################################################################

main "$@"
