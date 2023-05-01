#!/bin/sh

################################################################################
# Find files with trailing whitespace
################################################################################

main()
(
  # Find code with trailing whitespace
  grep -rn '[[:blank:]]$' libcxx/include libcxx/src libcxx/test libcxx/benchmarks
)

################################################################################

main "$@"
