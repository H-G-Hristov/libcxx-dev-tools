#!/bin/sh

################################################################################

test_suite="
"

################################################################################

cxx_standard_latest="c++23"

cxx_standards="
c++03
c++11
c++14
c++17
c++20
${cxx_standard_latest}
"

################################################################################

build_dirpath="" # e.g. `.`
test_tool_path="${build_dirpath}/bin"

output_dirpath="" # e.g. `.`
output_file_prefix="${output_dirpath}/"

################################################################################
# Examples
################################################################################

# Run all tests
# ninja -C ./build/default.debug.libcxx check-cxx check-cxxabi check-unwind

# Run all tests in subdirectory
# ./build/default.debug.libcxx/bin/llvm-lit -sv ./libcxx/test/std/ranges

# Run a single test file
# ./build/default.debug.libcxx/bin/llvm-lit -sv ./libcxx/test/std/ranges/range.adaptors/range.take.while/ctor.view.pass.cpp

# Test
# ./build/default.debug.libcxx/bin/llvm-lit -sv ./libcxx/test/libcxx/containers/sequences/deque/compare.three_way.pass.cpp

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
  if [ -z "${test_suite}" ]; then
    echo "Error: 'test_suite' is invalid..."
    exit 1
  fi

  if [ -z "${cxx_standard_latest}" ]; then
    echo "Error: 'cxx_standard_latest' is invalid..."
    exit 1
  fi

  if [ -z "${build_dirpath}" ]; then
    echo "Error: 'build_dirpath' is invalid..."
    exit 1
  fi

  if [ -z "${test_tool_path}" ]; then
    echo "Error: 'test_tool_path' is invalid..."
    exit 1
  fi

  if [ -z "${output_dirpath}" ]; then
    echo "Error: 'output_dir' is invalid..."
    exit 1
  fi

  if [ -z "${output_file_prefix}" ]; then
    echo "Error: 'output_file_prefix' is invalid..."
    exit 1
  fi
}

################################################################################

run_test() # test, cxx_standard, output_filename
{
  test="$1"
  cxx_standard="$2"
  output_filename="$3"

  cxx_standard_file_suffix=
  cxx_standard_param="${cxx_standard_latest}"

  if [ -n "${cxx_standard}" ]; then
    cxx_standard_file_suffix=".${cxx_standard}"
    cxx_standard_param="std=${cxx_standard}"
  fi

  # Print commands while executing
  set -x

  # Run a test suite (dump `stderr` and `stdout` streams and write them to a file and to the
  # console)
  "${test_tool_path}/llvm-lit" --param "${cxx_standard_param}" -sv "${test}" 2>&1 \
  | tee "${output_filename}${cxx_standard_file_suffix}.log"

  { set +x; } 2>/dev/null
}

################################################################################

main()
(
  check_settings
  check_output_dir

  # Run off variable value expansion except for splitting at newlines
  set -f; IFS='
  '
  for test in ${test_suite}; do
    # Restore globbing and field splitting at all whitespace
    { set +x; } 2>/dev/null; unset IFS
    output_filename="${output_file_prefix}$(echo "${test}" | sed -r 's/[\/]+/-/g')"

    if [ -z "${cxx_standards}" ]; then
      run_test "${test}" "${cxx_standard}" "${output_filename}"
    else
      for cxx_standard in ${cxx_standards}; do
        run_test "${test}" "${cxx_standard}" "${output_filename}"
      done
    fi
  done

  # Do it again in case `${test}` was empty
  { set +x; } 2>/dev/null; unset IFS
)

################################################################################

main "$@"
