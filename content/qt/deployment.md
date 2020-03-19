---
title: Deployment
weight: 5
---
All (or most) builds of Qt available in the official installer, Linux repositories, and brew are shared libraries or frameworks. This means that any executable built with these libraries will depend on Qt and won't run if Qt is not present on the end user's system.

It's possible to build Qt statically, so that you can build a standalone executable, but it's a more complicated process. Removing dependency on `vc-redist` dynamic library on Windows is also hard to do. It's much easier to use `macdeployqt` and `windeployqt` tools to create a directory that contains all required files. Rust-Qt crates don't support linking against static Qt builds.

Executables produced by Rust-Qt are much like normal executables produced by C++ compilers, so the deployment process doesn't differ from deploying a C++/Qt application. You can use official Qt deployment guides:

- [Windows](https://doc.qt.io/qt-5/windows-deployment.html)
- [macOS](https://doc.qt.io/qt-5/macos-deployment.html)
- [Linux](https://doc.qt.io/qt-5/linux-deployment.html)

For Windows, the basic idea is to copy your executable to a new directory and run `windeployqt` to populate it with all the files required by Qt. Note that executables produced by Visual Studio depend on Visual C++ Redistributable. `windeployqt` will copy the `vc_redist.x64.exe` installer to your destination directory, and your installer should run that to make sure the proper version of this library is available on the end user's system.

A common approach on Linux is to declare that your package depends on Qt libraries and only include your executable in the package. The system's package manager will ensure that Qt packages are installed. Refer to the documentation of the target Linux distributions for detailed instructions. 

This page doesn't cover deploying QML projects yet. For QML, you will also need to copy your QML files, pass `--qmldir` flag to `*deployqt` tool, and make sure your application can find these files at runtime. Another approach is to put the QML files in Qt resources, but there is no Rust tooling for that yet.
