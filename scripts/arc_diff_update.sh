#!/bin/sh

################################################################################

revision_number="" # [libc++] <patch title>

################################################################################

main_source_branch="main"

################################################################################

execution_dir=".."

################################################################################
# Examples
################################################################################

# Update a specific revision against branch `main` with the commits from the current branch.
# arc diff main --update D144822

################################################################################
# Run `arc` tool
################################################################################

check_settings()
{
  if [ -z "${revision_number}" ]; then
    echo "Error: empty revision number..." >&2
    exit 1
  fi

  if [ -z "${main_source_branch}" ]; then
    echo "Error: 'main_source_branch' is invalid..." >&2
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

  # { cd "${execution_dir}/"; } || exit 1

  arc diff "${main_source_branch}" --update "${revision_number}"
)

###############################################################################

main "$@"