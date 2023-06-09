#!/bin/sh

################################################################################

main_source_branch="main"

################################################################################
# Examples
################################################################################

# Create a new revision against branch `main` with the commits from the current
# branch.
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
}

################################################################################

main()
(
  check_settings

  arc diff "${main_source_branch}"
)

################################################################################

main "$@"
