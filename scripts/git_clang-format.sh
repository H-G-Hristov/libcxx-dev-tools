#!/bin/sh

################################################################################

main_source_branch="main"

################################################################################
# Examples
################################################################################

# Format the changes in the last commit:
# git clang-format HEAD^

# Format all changes between the `<main_branch>` branch and the last commit in
# the current branch:
# git clang-format <main_branch>...HEAD

################################################################################
# Run `arc` tool
################################################################################

check_settings()
{
  if [ -z "${main_source_branch}" ]; then
    echo "Error: 'main_source_branch' is invalid..." >&2
    exit 1
  fi
}

################################################################################

check_main_branch()
{
  GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  readonly GIT_BRANCH

  if [ "$GIT_BRANCH" = "${main_source_branch}" ]; then
    echo "Error: Patch cannot be applied on the current branch: '${main_source_branch}'..."
    echo "       Please create a new branch and try again!"
    exit 1;
  fi
}

################################################################################

main()
(
  check_settings
  check_main_branch

  git clang-format "${main_source_branch}"...HEAD
)

###############################################################################

main "$@"
