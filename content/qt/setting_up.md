---
title: Setting up
weight: 1
---
In addition to Rust's own build tools, you'll need to set up a C++ compiler, Qt, and CMake.

## C++ compiler

On Linux, install `gcc` from the repository.

On Windows, install Visual Studio (e.g. [Visual Studio Community 2017](https://www.visualstudio.com/thank-you-downloading-visual-studio/?sku=Community&rel=15)). Make sure to enable the component for C++ application development when installing Visual Studio. 

Visual Studio will create a starting menu option (e.g. `x64 Native Tools Command Prompt for VS 2017`) for starting command prompt with environment variables set up. You need to use it for all build operations, so that VS compiler and linker are available. 

On macOS, install Xcode Command Line Tools. The install can be initiated with the `xcode-select --install` command. You don't need a full Xcode installation.

## Qt

You can install Qt on any OS using the [official installer](https://www.qt.io/download). The installer allows you to select one of multiple available versions and builds. Make sure to select a `Desktop` build, not a mobile OS build. On Windows, also make sure to select a build corresponding to your Visual Studio version (e.g. `MSVC 2017`), not a MinGW build. Select a 64-bit version, not a 32-bit version.

On Linux and macOS, you can also install Qt development packages from the repository (or `brew`).

If Qt is not installed system-wide, you need to set up `PATH` to point at the directory where `qmake` executable is stored. You may also need to set up variables that allow the dynamic linker to find Qt libraries at runtime:

On Linux:
```bash
export PATH="~/Qt/5.14.0/gcc_64/bin:$PATH"
export LD_LIBRARY_PATH="~/Qt/5.14.0/gcc_64/lib:$PATH"
```

On macOS:

```bash
export PATH="~/Qt/5.14.0/gcc_64/bin:$PATH"
# If Qt is build as libraries:
export DYLD_LIBRARY_PATH=~/Qt/5.14.0/clang_64/lib:$DYLD_LIBRARY_PATH
# If Qt is build as frameworks:
export DYLD_FRAMEWORK_PATH=~/Qt/5.14.0/clang_64/lib:$DYLD_FRAMEWORK_PATH
```

On Windows (in the VS command prompt):
```bat
set PATH=C:\Qt\5.13.0\msvc2017_64\bin;%PATH%
```

## CMake

You'll also need `cmake`. On Linux and macOS, install it from the repository (or `brew`). 

On Windows, download the CMake installer at the [official site](https://cmake.org). During installation, choose to add `cmake` to the system `PATH`. You'll need to reopen command prompt or log out to apply the changes. Alternatively, add its installation directory to `PATH` in your prompt. 

Run `cmake --version` to verify that `cmake` is available.

## Verifying installation

To check that everything is set up correctly, try to build a C++/Qt project in your environment. If you've installed Qt via the official installer, it will store examples in the `Examples` directory of your Qt installation. You can also find them in the [Qt git repository](https://code.qt.io/cgit/qt/qtbase.git/tree/examples).

On Linux:
```bash
cd /tmp
mkdir build
cd build
qmake ~/Qt/Examples/Qt-5.13.0/widgets/dialogs/standarddialogs
make
./standarddialogs
```

On macOS:
```bash
cd /tmp
mkdir build
cd build
qmake ~/Qt/Examples/Qt-5.13.0/widgets/dialogs/standarddialogs
make
open standarddialogs.app
```

On Windows (in the VS command prompt):
```bat
cd C:\tmp
mkdir build
cd build
qmake C:\Qt\Examples\Qt-5.13.0\widgets\dialogs\standarddialogs
nmake
release\standarddialogs.exe
```

Finally, you can try to build the provided examples:
```bash
git clone https://github.com/rust-qt/examples
cd examples
cargo run --bin basic_form
```

If you use MSYS2 and you get the following error: "The procedure entry point inflateValidate could not be located in the dynamic link library C:\msys64\mingw64\bin\libpng16-16.dll", it's usually caused by some other zlib1.dll on your PATH. You can verify this from MSYS2 shell using the following commmand:
```bash
which zlib1.dll
```
To fix this, you either need to fix your PATH or copy zlib1.dll from your `C:\msys64\mingw64\bin` directory to your `target\debug` and `target\release` directories.
