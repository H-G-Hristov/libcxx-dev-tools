#!/bin/sh

################################################################################

all_tests="
check-cxx
check-cxxabi
check-unwind
"

################################################################################

build_dirpath="" # e.g. '.'
build_path="${build_dirpath}/"

output_dirpath="" # e.g. '.'
output_file="${output_dirpath}/all_tests.log"

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
  if ! [ -d "${output_dirpath}" ]; then
    mkdir -p "${output_dirpath}" || {
      echo "Error: Failed to create '${output_dirpath}"
      exit 1
    }
  fi
}

check_settings()
{
  if [ -z "${build_dirpath}" ]; then
    echo "Error: 'build_dirpath' is invalid..." >&2
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
}

################################################################################

main()
(
  check_settings
  check_output_dir

  # Run all tests (dump stderr and stdout streams and write them to a file and to the console)
  ninja -C "${build_path}" "${all_tests}" 2>&1 | tee "${output_file}"
)

################################################################################

main "$@"
