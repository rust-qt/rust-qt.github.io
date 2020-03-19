---
title: Setting up
weight: 1
---
## Using docker (recommended)

To make sure the parsing results are consistent and reproducible, it's recommended to use a reproducible environment, such as provided by `docker`.

Ritual provides `Dockerfile`s containing its dependencies:

- `docker.builder.dockerfile` is the base image suitable for working on C++'s standard library. It also should be used as a base image when working on other C++ libraries.
- `docker.qt.dockerfile` is the image used for generating Qt crates. 

You can build the images with these commands:
```bash
cd ritual
# for any libraries
docker build . -f docker.builder.dockerfile -t ritual_builder

# only for Qt
docker build . -f docker.qt.dockerfile --target qt_downloader -t ritual_qt_downloader
docker build . -f docker.qt.dockerfile -t ritual_qt
```

Note that the image contains only the environment. No pre-built ritual artifacts are included. This allows you to edit the source code of your generator and re-run it without the slow process of rebuilding the docker image. You can use `cargo` to run the generator, just like you would normally do it on the host system.

When running the container, mount `/build` to a persistent directory on the host system. This directory will contain all temporary build files, so making it persistent will allow you to recreate the container without having to recompile everything from scratch.  

In addition to the build directory, you should also mount one or more directories containing the source code of your generator and the ritual workspace directory (see below) to make it available in the container. The paths to these directories can be arbitrary.

This is an example of command that runs a shell in the container:
```bash
docker run \
    --mount type=bind,source=~/ritual/repo,destination=/repo \
    --mount type=bind,source=~/ritual/qt_workspace,destination=/qt_workspace \
    --mount type=bind,source=~/ritual/tmp,destination=/build \
    --name ritual_qt \
    --hostname ritual_qt \
    -it \
    ritual_qt \
    bash
```

Use `cargo` to run the generator inside the container, just like in the host system.

## Without docker

In case you don't want or can't use `docker`, you can just install all required dependencies on your host system and run your generator natively with `cargo`, like any Rust project.

`ritual` requires:

- A C++ build toolchain, compatible with the Rust toolchain in use:
  - On Linux: `make` and a C++ compiler;
  - On Windows: MSVC (Visual Studio or build tools) or MinGW environment;
  - On OS X: the command line developer tools (full Xcode installation is not required);
- The target C++ library (include and library files);
- [cmake](https://cmake.org/) ≥ 3.0;
- `libclang-dev` ≥ 3.5;
- `libsqlite3-dev` (only for `qt_ritual`).

Note that C++ toolchain, Rust toolchain, and Qt build must be compatible. For example, MSVC and MinGW targets on Windows are not compatible. 

The following environment variables may be required for `clang` parser to work correctly:

- `LLVM_CONFIG_PATH` (path to `llvm-config` binary)
- `CLANG_SYSTEM_INCLUDE_PATH` (e.g. `$CLANG_DIR/lib/clang/3.8.0/include` for `clang` 3.8.0).

If a parse error like `fatal error: 'stddef.h' file not found` is produced when running the generator, check that `CLANG_SYSTEM_INCLUDE_PATH` variable is set correctly.

If `libsqlite3` is not installed system-wide, setting `SQLITE3_LIB_DIR` environment variable may be required.

Run `cargo test` to make sure that dependencies are set up correctly.

`RITUAL_TEMP_TEST_DIR` variable may be used to specify location of the temporary directory used by tests. If the directory is preserved between test runs, tests will run faster.

`RITUAL_WORKSPACE_TARGET_DIR` variable overrides the `cargo`'s target directory when `ritual` runs `cargo` on the generated crates.

Build scripts of generated crates accept `RITUAL_LIBRARY_PATH`, `RITUAL_FRAMEWORK_PATH`, `RITUAL_INCLUDE_PATH` environment variables. They can be used to override paths selected by the build script (if any). If multiple paths need to be specified, separate them in the same way `PATH` variable is separated on your platform. Additionally, `RITUAL_CMAKE_ARGS` allows you to specify additional arguments passed to `cmake` when building C++ glue library.

C++ build tools and the linker may also read other environment variables, including `LIB`, `PATH`, `LIBRARY_PATH`, `LD_LIBRARY_PATH`, `DYLD_FRAMEWORK_PATH`. The generator has API for specifying library paths, passes them to `cmake` when building the C++ wrapper library, and reports the paths in build script's output, but it may not be enough for the linker to find the library, so you may need to set them manually.
