#!/bin/sh

################################################################################

output_dirpath="" # e.g. `.`
diff_file_prefix="${output_dirpath}/"

################################################################################

current_branch=$(git symbolic-ref --short HEAD)
output_file_base=$(echo "${current_branch}" | sed "s/\//-/g")
output_file="${diff_file_prefix}${output_file_base}.patch"

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
# Diff
################################################################################

check_output_dir()
{
  if ! [ -d "${output_dirpath}" ]; then
    mkdir -p "${output_dirpath}" || {
      echo "Error: Failed to create '${output_dirpath}"
      exit 1
    }
  fi
}

check_settings()
{
  if [ -z "${main_source_branch}" ]; then
    echo "Error: 'main_source_branch' is invalid..." >&2
    exit 1
  fi

  if [ -z "${diff_file_prefix}" ]; then
    echo "Error: 'diff_file_prefix' is invalid..." >&2
    exit 1
  fi

  if [ -z "${current_branch}" ]; then
    echo "Error: 'current_branch' is invalid..." >&2
    exit 1
  fi

  if [ -z "${output_file_base}" ]; then
    echo "Error: 'output_file_base' is invalid..." >&2
    exit 1
  fi

  if [ -z "${output_file}" ]; then
    echo "Error: 'output_file' is invalid..." >&2
    exit 1
  fi
}

################################################################################

rotate_diffs() # filename, output_dirpath
{
  FILENAME=$(basename "$1" ".patch")
  readonly FILENAME
  readonly OUT_DIRPATH="$2"

  # Get a list of all of the already rotated files in reverse
  # '${filename}.3.patch' '${filename}.2.patch' '${filename}.1.patch'
  PATCH_FILES=$(find "${OUT_DIRPATH}" -type f -iname "${FILENAME}.*.patch" | sort -r)
  readonly PATCH_FILES

  for file in ${PATCH_FILES}; do
    # Restore globbing and field splitting at all whitespace
    { set +x; } 2>/dev/null; unset IFS
    base_filename=$(basename "${file}")

    # Calculate the next number for the current file, i.e. '4' for '${filename}.3.patch'
    old_index=$(echo "${base_filename}" | sed -nE "s/^${FILENAME}\.([0-9]*)\.patch$/\1/p")
    new_index=$((old_index + 1))

    # If the new file number is greater than max, delete it.
    if [ "${new_index}" -gt "${max:-999999}" ]; then
      rm -rf "${file}"
    else
      base_filename=$(basename "${base_filename}" ".${old_index}.patch")
      # Otherwise move the file to the new number.
      mv "${file}" "${OUT_DIRPATH}/${base_filename}.${new_index}.patch"
    fi
  done

  # Do it again in case `${file}` was empty
  { set +x; } 2>/dev/null; unset IFS

  # If there is a `${FILENAME}` file with no extension move that now.
  if [ -e "${OUT_DIRPATH}/${FILENAME}.patch" ]; then
    mv "${OUT_DIRPATH}/${FILENAME}.patch" "${OUT_DIRPATH}/${FILENAME}.0.patch"
  fi
}

################################################################################

main()
(
  check_settings
  check_output_dir

  rotate_diffs "${output_file}" "${output_dirpath}"

  # Get a diff between the 'main' branch and the current branch
  git diff "${main_source_branch}"...HEAD > "${output_file}"
)

################################################################################

main "$@"
