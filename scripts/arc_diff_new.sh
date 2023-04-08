#!/bin/sh

################################################################################

main_source_branch="main"

################################################################################

execution_dir=".."

################################################################################
# Examples
################################################################################

# Create a new revision against branch `main` with the commits from the current branch.
# arc diff main

################################################################################
# Run `arc` tool
################################################################################

check_settings()
{
  if [ -z "${main_source_branch}" ]; then
    echo "Error: 'main_source_branch' is invalid..."
    exit 1
  fi

  if [ -z "${execution_dir}" ]; then
    echo "Error: 'execution_dir' is invalid..."
    exit 1
  fi
}

################################################################################

main()
(
  check_settings

  # Print commands while executing
  # set -x

  # { cd "${execution_dir}/"; } || exit 1

  arc diff "${main_source_branch}"
)

################################################################################

main "$@"
