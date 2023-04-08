#!/bin/sh

################################################################################

main_branch="main"

################################################################################

output_dir="."
diff_file_prefix="${output_dir}/"

current_branch=$(git symbolic-ref --short HEAD)
output_file_base=$(echo "${current_branch}" | sed "s/\//-/g")
output_file="${diff_file_prefix}${output_file_base}.patch"

################################################################################

execution_dir=".."

################################################################################
# `HEAD`` - current branch
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
  if ! [ -d "${output_dir}" ]; then
    mkdir -p "${output_dir}" || {
      echo "Error: Failed to create '${output_dir}"
      exit 1
    }
  fi
}

check_settings()
{
  if [ -z "${main_branch}" ]; then
    echo "Error: 'main_branch' is invalid..." >&2
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

  if [ -z "${execution_dir}" ]; then
    echo "Error: 'execution_dir' is invalid..." >&2
    exit 1
  fi
}

################################################################################

rotate_diffs() # filename
{
  filename=$(basename "$1" ".patch")

  # Get a list of all of the already rotated files in reverse
  # '${filename}.3.patch' '${filename}.2.patch' '${filename}.1.patch'
  for file in $(ls -1r "${filename}."*".patch" 2> /dev/null); do
    # Calculate the next number for the current file, i.e. '4' for '${filename}.3.patch'
    old_index=$(echo "${file}" | sed -nE "s/^${filename}\.([0-9]*)\.patch$/\1/p")
    new_index=$((old_index + 1))
    # If the new file number is greater than max, delete it.
    if [ "${new_index}" -gt "${max:-999999}" ]; then
      rm -rf "${file}"
    else
      name=$(basename "${file}" ".${old_index}.patch")
      # name=$(basename "${name}" ".${name##*.}")
      # Otherwise move the file to the new number.
      mv "${file}" "${name}.${new_index}.patch"
    fi
  done

  # If there is a '${filename}' file with no extension move that now.
  if [ -e "${filename}.patch" ]; then
    mv "${filename}.patch" "${filename}.0.patch"
  fi
}

################################################################################

main()
(
  check_settings
  check_output_dir

  # Print commands while executing
  # set -x

  # { cd "${execution_dir}"; } || exit 1

  rotate_diffs "${output_file}"

  # git diff "${main_branch}" > "${output_file}"

  # Get a diff between the main branch and the current branch
  git diff "${main_branch}"...HEAD > "${output_file}"
)

################################################################################

main "$@"
