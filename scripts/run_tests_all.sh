#!/bin/sh

################################################################################

build_path=""

all_tests="
check-cxx
check-cxxabi
check-unwind 
"

################################################################################

output_dir="."
output_file="${output_dir}/all_tests.log"

################################################################################

execution_dir=".."

################################################################################
# Examples
################################################################################

# Run all tests
# ninja -C ./build/default.debug.libcxx check-cxx check-cxxabi check-unwind

################################################################################
# Test
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
  if [ -z "${build_path}" ]; then
    echo "Error: 'build_path' is invalid..." >&2
    exit 1
  fi

  if [ -z "${all_tests}" ]; then
    echo "Error: 'all_tests' is invalid..." >&2
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

main()
(
  check_settings
  check_output_dir

  # Print commands while executing
  # set -x

  # { cd "${execution_dir}/"; } || exit 1

  # Run all tests
  # ninja -C "${build_path}" check-cxx check-cxxabi check-unwind

  # Run all tests with verbose output
  # ninja -vC "${build_path}" check-cxx check-cxxabi check-unwind

  # Run all tests and log to a file
  # ninja -C "${build_path}" check-cxx check-cxxabi check-unwind > "${output_file}"

  # Run all tests (dump stderr and stdout streams and write them to a file and to the console)
  ninja -C "${build_path}" "${all_tests}" 2>&1 | tee "${output_file}"
)

################################################################################

main "$@"
