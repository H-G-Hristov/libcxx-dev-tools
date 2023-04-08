#!/bin/sh

################################################################################

target_directory="./zsh_out_tests"
file_pattern="*.log" # Test log files pattern

################################################################################

execution_dir=".."

################################################################################
# Delete test files files
################################################################################

check_settings()
{
  if [ -z "${file_pattern}" ]; then
    echo "Error: 'file_pattern' is invalid..." >&2
    exit 1
  fi

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

  find "${target_directory}" -maxdepth 1 -type f -name "${file_pattern}" -delete
)

################################################################################

main "$@"
