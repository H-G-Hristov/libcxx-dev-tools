#!/bin/sh

################################################################################

test_suite="
"

################################################################################

cxx_standard_latest="c++2b"

cxx_standards="
c++03
c++11
c++14
c++17
c++20
${cxx_standard_latest}
"

build_path="."
test_tool_path="${build_path}/bin"

output_dir="."
output_file_prefix="${output_dir}/"

################################################################################

execution_dir=".."

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
  if ! [ -d "${output_dir}" ]; then
    mkdir -p "${output_dir}" || {
      echo "Error: Failed to create '${output_dir}"
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

  if [ -z "${build_path}" ]; then
    echo "Error: 'build_path' is invalid..."
    exit 1
  fi

  if [ -z "${test_tool_path}" ]; then
    echo "Error: 'test_tool_path' is invalid..."
    exit 1
  fi

  if [ -z "${output_dir}" ]; then
    echo "Error: 'output_dir' is invalid..."
    exit 1
  fi

  if [ -z "${output_file_prefix}" ]; then
    echo "Error: 'output_file_prefix' is invalid..."
    exit 1
  fi

  if [ -z "${execution_dir}" ]; then
    echo "Error: 'execution_dir' is invalid..."
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

  # Run a test suite
  # "${test_tool_path}/llvm-lit" -sv "${test_suite}"

  # Run a test suite and log to a file
  # "${test_tool_path}/llvm-lit" -sv "${test_suite}" > "${output_file}"

  # # Print commands while executing.
  # set -x # Print commands while executing.
  # # Run a test suite (dump stderr and stdout streams and write them to a file and to the console)
  # "${test_tool_path}/llvm-lit" --param "std=${cxx_standard}" -sv "${test}" 2>&1 | tee "${output_file}.${cxx_standard}.log"
  # { set +x; } 2>/dev/null

  # Run a test suite (dump stderr and stdout streams and write them to a file and to the console)
  "${test_tool_path}/llvm-lit" --param "${cxx_standard_param}" -sv "${test}" 2>&1 \
  | tee "${output_filename}${cxx_standard_file_suffix}.log"

  # Run a test suite (dump stderr and stdout streams and write them to a file)
  # "${test_tool_path}/llvm-lit" --param "${cxx_standard_param}" -sv "${test}" > "${output_filename}${cxx_standard_file_suffix}.log" 2>&1

  { set +x; } 2>/dev/null
}

################################################################################

main()
(
  check_settings
  check_output_dir

  # Print commands while executing
  # set -x

  # { cd "${execution_dir}"; } || exit 1

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

  # Do it again in case ${test} was empty
  { set +x; } 2>/dev/null; unset IFS
)

################################################################################

main "$@"
