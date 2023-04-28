#!/bin/sh

################################################################################

output_dirpath="" # e.g. `.`
target_directory="${output_dirpath}/" # Target directory for tests results

file_pattern="*.log" # Test log files pattern

################################################################################
# Delete test files files
################################################################################

check_settings()
{
  if [ -z "${file_pattern}" ]; then
    echo "Error: 'file_pattern' is invalid..." >&2
    exit 1
  fi
}

################################################################################

main()
(
  check_settings

  find "${target_directory}" -maxdepth 1 -type f -name "${file_pattern}" -delete
)

################################################################################

main "$@"
