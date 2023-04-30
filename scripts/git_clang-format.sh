#!/bin/sh

################################################################################

main_source_branch="main"

################################################################################
# `HEAD` - current branch
################################################################################
#
# G   H   I   J
#  \ /     \ /
#   D   E   F
#    \  |  / \
#     \ | /   |
#      \|/    |
#       B     C
#        \   /
#         \ /
#          A
# A =      = A^0
# B = A^   = A^1     = A~1
# C = A^2
# D = A^^  = A^1^1   = A~2
# E = B^2  = A^^2
# F = B^3  = A^^3
# G = A^^^ = A^1^1^1 = A~3
# H = D^2  = B^^2    = A^^^2  = A~2^2
# I = F^   = B^3^    = A^^3^
# J = F^2  = B^3^2   = A^^3^2
#
# Both commit nodes B and C are parents of commit node A. Parent commits are
# ordered left-to-right.
#
################################################################################

################################################################################
# Examples
################################################################################

# Format the changes in the last commit:
# git clang-format HEAD^

# Format all changes between the `<main_branch>` branch and the last commit in
# the current branch:
# git clang-format <main_branch>...HEAD

################################################################################
# Run `clang-format` tool
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
