# How-To Contribute to ***`libc++`*** - Starter Guide

## References

1. Read:
    - [LLVM - Getting Involved](https://llvm.org/docs/GettingInvolved.html)
      - [Contributing to LLVM](https://llvm.org/docs/Contributing.html)
      - [LLVM Developer Policy](https://llvm.org/docs/DeveloperPolicy.html)
      - [LLVM Code-Review Policy and Practices](https://llvm.org/docs/CodeReview.html)
    - [***“libc++”*** C++ Standard Library](https://libcxx.llvm.org/index.html)
      - [Building libc++](https://libcxx.llvm.org/BuildingLibcxx.html)
      - [Testing libc++](https://libcxx.llvm.org/TestingLibcxx.html)
      - [Contributing to libc++](https://libcxx.llvm.org/Contributing.html)
2. Further reading:
    - C++ Standard
      - [ISO C++ Standard Draft (html)](https://eel.is/c++draft/)
      - [ISO C++ Standard Draft (n4928.pdf)](https://open-std.org/JTC1/SC22/WG21/docs/papers/2023/n4928.pdf)
      - [ISO Papers](https://open-std.org/JTC1/SC22/WG21/docs/papers/2023/)
    - Contibuting:
      - [How to contribute to LLVM](https://developers.redhat.com/articles/2022/12/20/how-contribute-llvm#)
    - Debugging:
      - [Debugging the C++ standard library on macOS](https://www.jviotti.com/2022/05/05/debugging-the-cxx-standard-library-on-macos.html)
      - [Debugging llvm-lit in vscode](https://weliveindetail.github.io/blog/post/2021/08/06/debug-llvm-lit.html)
    - LLVM
      - [Pre-Release](https://prereleases.llvm.org)
    - C++ Standard Library Implementations
      - [Microsoft's C++ Standard Library](https://github.com/microsoft/STL)
      - [libstdc++ Source Documentation](https://gcc.gnu.org/onlinedocs/libstdc++/latest-doxygen/index.html)

## Tools

### ***Visual Studio Code***

- Extensions

> `./.vscode/extension.json`

```json5
{
  "recommendations": [
    // Bookmarks
    "alefragnani.bookmarks",
    // C++ (meta extension)
    "ms-vscode.cpptools-extension-pack",
    // C++
    "jeff-hykin.better-cpp-syntax",
    "ms-vscode.cpptools-themes",
    "ms-vscode.cpptools",
    // CMake
    "twxs.cmake",
    "ms-vscode.cmake-tools",
    // EditorConfig
    "EditorConfig.EditorConfig",
    // Git
    "mhutchie.git-graph",
    "eamodio.gitlens",
    "github.vscode-pull-request-github",
    // Markdown Lint
    "davidanson.vscode-markdownlint",
    // Shell Script Lint
    "timonwong.shellcheck",
  ]
}
```

- ***CMake** presets

> `./runtimes/CMakeUserPresets.json`

```json
{
  "version": 9,
  "cmakeMinimumRequired": {
    "major": 3,
    "minor": 30,
    "patch": 0
  },
  "configurePresets": [
    {
      "name": "default",
      "displayName": "Default Config",
      "description": "Default build using Ninja generator",
      "hidden": true,
      "generator": "Ninja",
      "binaryDir": "${sourceParentDir}/build/${presetName}"
    },
    {
      "name": "default.debug.libcxx",
      "displayName": "Debug libc++",
      "description": "libc++ debug configuration",
      "inherits": [
        "default"
      ],
      "cacheVariables": {
        "LLVM_ENABLE_RUNTIMES": {
          "type": "STRING",
          "value": "libcxx;libcxxabi;libunwind"
        },
        "CMAKE_EXPORT_COMPILE_COMMANDS": {
          "type": "BOOL",
          "value": "ON"
        },
        "CMAKE_BUILD_TYPE": {
          "type": "STRING",
          "value": "Debug"
        },
        "LIBCXX_ENABLE_DEBUG_MODE": {
          "type": "BOOL",
          "value": "ON"
        },
        "LIBCXX_HARDENING_MODE": {
          "type": "STRING",
          "value": "debug"
        }
      }
    }
  ],
  "buildPresets": [
    {
      "name": "default",
      "configurePreset": "default.debug.libcxx"
    }
  ]
}

```

- ***cppdbg*** settings

> `./.vscode/launch.json`

```json5
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "name": "(lldb) Launch",
      "type": "cppdbg",
      "request": "launch",
      // Resolved by CMake Tools:
      "program": "${command:cmake.launchTargetPath}",
      "args": [],
      "stopAtEntry": false,
      "cwd": "${fileDirname}",
      "environment": [],
      "externalConsole": false,
      "MIMode": "lldb"
    },
    {
      "name": "(lldb) Attach",
      "type": "cppdbg",
      "request": "attach",
      // Resolved by CMake Tools:
      "program": "${command:cmake.launchTargetPath}",
      "MIMode": "lldb"
    },
  ]
}

```

- ***CodeLLDB*** settings

> `./.vscode/launch.json`

```json5
{
  // Use IntelliSense to learn about possible attributes.
  // Hover to view descriptions of existing attributes.
  // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
  "version": "0.2.0",
  "configurations": [
    {
      "type": "lldb",
      "request": "launch",
      "name": "Launch",
      // Resolved by CMake Tools:
      "program": "${command:cmake.launchTargetPath}",
      "args": [],
      "cwd": "${workspaceFolder}",
      "initCommands": [
        // Disable stepping into the C++ Standard Library, 'boost::shared_ptr'
        // "settings set target.process.thread.step-avoid-regexp ^(std::|boost::shared_ptr)",
        // Enable stepping into the C++ Standard Library
        "settings set target.process.thread.step-avoid-regexp ''"
      ],
    },
  ]
}
```

### ***git***

- Configure ***git*** as described in [GitHub SSH Setup](github_ssh_setup.md)

- To exclude files from ***git*** for the current repository add them to `.git/info/exclude`

```ini
# git ls-files --others --exclude-from=.git/info/exclude
# Lines that start with '#' are comments.
# For a project mostly in C, the following would be a good set of
# exclude patterns (uncomment them if you want to use them):
# *.[oa]
# *~

# Directories
**/libcxx-*/
**/z_libcxx-*/
**/z_test_bed/
**/zsh*/

# Misc files
.editorconfig

```

### Formatting Code

#### Using ***git***

To format the changes in the last commit:

```sh
git clang-format HEAD^
```

To format all changes between the `<main_branch>` branch and the last commit in the current branch:

```sh
git clang-format <main_branch>...HEAD
```

#### Using ***Visual Studio Code***

Visual studio code provides the following code formatting menu items:

- `Format Document`
- `Format Selection`

##### Test Bed Project

- ***CMake*** presets:

> `./z_test_bed/CMakePresets.json`

```json5
{
  "version": 9,
  "cmakeMinimumRequired": {
    "major": 3,
    "minor": 30,
    "patch": 0
  },
  "configurePresets": [
    {
      "name": "default",
      "displayName": "Default Config",
      "description": "Default build using Ninja generator",
      "hidden": true,
      "generator": "Ninja",
      "binaryDir": "${sourceParentDir}/build/${presetName}"
    },
    {
      "name": "default.debug.libcxx.testing",
      "displayName": "Debug libc++ Testing",
      "description": "libc++ debug configuration",
      "inherits": [
        "default"
      ],
      "cacheVariables": {
        "CMAKE_BUILD_TYPE": "Debug",
        "LIBCXX_ENABLE_DEBUG_MODE": "ON"
      }
    }
  ],
  "buildPresets": [
    {
      "name": "default",
      "configurePreset": "default.debug.libcxx.testing"
    }
  ]
}

```

> `./z_test_bed/CMakeUserPresets.json`

```json5
{
  "version": 9,
  "cmakeMinimumRequired": {
    "major": 3,
    "minor": 30,
    "patch": 0
  },
  "configurePresets": [],
  "buildPresets": []
}

```

> `./z_test_bed/CMakeLists.txt`

```json5
cmake_minimum_required(VERSION 3.30.0)

project("LLVM-Testing")

add_executable(${PROJECT_NAME})

set(LLVM_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../")
set(LIBCXX_BUILD_DIR "${LLVM_SOURCE_DIR}/build/default.debug.libcxx")
set(LIBCXX_INCLUDE_DIR "${LIBCXX_BUILD_DIR}/include/c++/v1")
set(LIBCXX_LIB_DIR "${LIBCXX_BUILD_DIR}/lib")

message("LLVM_SOURCE_DIR:    ${LLVM_SOURCE_DIR}")
message("LIBCXX_BUILD_DIR:   ${LIBCXX_BUILD_DIR}")
message("LIBCXX_INCLUDE_DIR: ${LIBCXX_INCLUDE_DIR}")
message("LIBCXX_LIB_DIR:     ${LIBCXX_LIB_DIR}")

target_compile_definitions(${PROJECT_NAME}
  PRIVATE
    "_LIBCPP_ENABLE_EXPERIMENTAL"
)

target_compile_options(${PROJECT_NAME}
  PRIVATE
    -nostdinc++
    -nostdlib++
    -isystem ${LIBCXX_INCLUDE_DIR}
    # "-L ${LIBCXX_LIB_DIR}"
    # "-lc++"
    # "-Wl,-rpath,${LIBCXX_LIB_DIR}"
)

target_link_libraries(${PROJECT_NAME}
  PRIVATE
    libc++experimental.a
)

target_link_options(${PROJECT_NAME}
  PRIVATE
    # -fexperimental-library
    -L ${LIBCXX_LIB_DIR}
    -lc++
    -Wl,-rpath,${LIBCXX_LIB_DIR}
)

target_include_directories(${PROJECT_NAME}
  PRIVATE
    "${CMAKE_CURRENT_LIST_DIR}/include"
    "${CMAKE_CURRENT_LIST_DIR}/../libcxx/test/support"
)

set_target_properties(${PROJECT_NAME}
  PROPERTIES
    CXX_EXTENSIONS OFF
    CXX_STANDARD 26
    CXX_STANDARD_REQUIRED ON
)

target_sources(${PROJECT_NAME}
  PRIVATE
    "src/main.cpp"
)

```
