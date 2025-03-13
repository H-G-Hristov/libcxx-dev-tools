#!/bin/sh

################################################################################

build_dirpath="" # e.g. `.`

################################################################################
# Generator
################################################################################

check_settings()
{
  if [ -z "${build_dirpath}" ]; then
    echo "Error: 'build_path' is invalid..." >&2
    exit 1
  fi
}

################################################################################

main()
(
  check_settings

  # Run
  ninja -C "${build_dirpath}" libcxx-generate-files
  ninja -C "${build_dirpath}" generate-cxx-abilist

  echo "QUESTION: Do you want to run the transitive include generator script? (y/n)"
  echo "          Set 'regenerate_expected_results = True' before running the generator script."
  read -r answer

  if [ "${answer}" != "${answer#[Yy]}" ]; then
    # Set `regenerate_expected_results` to `True`, e.g. `regenerate_expected_results = True` in
    #   libcxx/test/libcxx/transitive_includes.gen.py
    for std in c++03 c++11 c++14 c++17 c++20 c++23 c++26;
    do
      "${build_dirpath}/bin/llvm-lit" --param std=$std libcxx/test/libcxx/transitive_includes.gen.py;
    done
  fi
)

################################################################################

main "$@"
