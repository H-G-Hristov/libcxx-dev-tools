#!/bin/sh

################################################################################

revision_number="" # [libc++] <patch title>

################################################################################

output_dirpath="" # e.g. `.`
temp_patch_directory="${output_dirpath}/" # Target temporary directory

################################################################################

main_source_branch="main"

################################################################################
# Examples
################################################################################

# WARNING: Applying patches requires a patch for 'archanist', see:
# https://www.llvm.org/docs/Phabricator.html#requesting-a-review-via-the-command-line

# Export the local changeset to a file in 'git diff' format:
# arc export --git --revision D132265 > D132265.patch

# Apply the changes in a patchfile to the working copy:
# arc patch --patch D132265.patch

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

  if [ -z "${output_dirpath}" ]; then
    echo "Error: 'output_dirpath' is invalid..." >&2
    exit 1
  fi

  if [ -z "${temp_patch_directory}" ]; then
    echo "Error: 'temp_patch_directory' is invalid..." >&2
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

  if ! [ -d "${temp_patch_directory}" ]; then
    echo "$PWD"
    echo "Error: Temp directory ${temp_patch_directory} does not exist!"
    exit 1;
  fi

  readonly PATCH_FILENAME="${revision_number}.patch"
  readonly PATCH_FILEPATH="${temp_patch_directory}/${PATCH_FILENAME}"

  arc export --git --revision "${revision_number}" > "${PATCH_FILEPATH}"

  if [ -f "${PATCH_FILEPATH}" ]; then
    arc patch --patch "${PATCH_FILEPATH}" --trace

    rm -i "${PATCH_FILEPATH}"
  else
    echo "Error: File not found '${PATCH_FILEPATH}'"
  fi
)

###############################################################################

main "$@"
