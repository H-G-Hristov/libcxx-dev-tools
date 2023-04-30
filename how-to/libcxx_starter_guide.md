# How-To Contribute to ***`libc++`*** Starter Guide

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
    - [Code Reviews with Phabricator](https://www.llvm.org/docs/Phabricator.html)
      - [Arcanist User Guide](https://secure.phabricator.com/book/phabricator/article/arcanist/)
        - [Arcanist Quick Start](https://secure.phabricator.com/book/phabricator/article/arcanist_quick_start/)
        - [`arc diff`](https://secure.phabricator.com/book/phabricator/article/arcanist_diff/)
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

- ***CodeLLDB*** settings

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
**/z_libcxx_*/
**/zsh*/

# Misc files
.editorconfig

```

### ***Arcanist***

#### General Workflow

1. Select a repository: `cd <repository_path>`
2. Checkout a branch with changes: `git checkout <branch_name>`
3. Create a draft: `arc diff <main_branch> --draft`
4. Pull **`main`** and rebase.
5. Update the patch: `arc diff <main_branch> --update <revision_number>`
6. Land the patch: `arc land`

#### Landing a patch

The simplest way to ***land*** a patch is to use `arc land`. In case of an error retry as many times as necessarily:

```sh
cd <cloned repository>
git checkout <branch>
arc land
```

WARNING: Rebase against **`main`** before updating the diff with ***Arcanist***. Don't rebase manually before landing.

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
