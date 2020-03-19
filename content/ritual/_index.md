---
menu: main
title: About Ritual
weight: 1
---
## C++/Rust features coverage

Supported features:

- Primitive types are mapped to Rust's primitive types (like `bool`) and FFI types (like `c_int`).
- Fixed-size numeric types (e.g `int8_t` or `qint8`) are mapped to Rust's fixed size types (e.g. `i8`).
- Pointers, references and values are mapped to special smart pointer types (`Ref`, `Ptr`, `CppBox`, etc.) provided by the `cpp_core` crate.
- C++ namespaces are mapped to Rust modules.
- C++ classes, structs, and enums are mapped to Rust structs. This also applies to all instantiations of template classes encountered in the library's API, including template classes of dependencies.
- Free functions are mapped to free functions.
- Class methods are mapped to structs' implementations.
- Destructors are mapped to `CppDeletable` implementations and can be automatically invoked by `CppBox`.
- Function pointer types are mapped to Rust's equivalent representation. Function pointers with references or class values are not supported.
- `static_cast` and `dynamic_cast` are available in Rust through corresponding traits.
- Methods inherited from base classes are available via `Deref` implementation (if the class has multiple bases, only the first base's methods are directly available).
- Getter and setter methods are created for each public class field.
- Operators are translated to Rust's operator trait implementations when possible.
- C++ STL-style iterators are accessible from Rust via adaptors.

Names of Rust identifiers are modified according to Rust's naming conventions.

Documentation is important! `ritual` generates `rustdoc` comments with information about corresponding C++ types and methods. Qt documentation is integrated in `rustdoc` comments.

Not implemented yet but can be implemented in the future:

- Translate C++ `typedef`s to Rust type aliases.
- Implement `Debug` and `Display` traits for structs if applicable methods exist on C++ side.
- ([Implement subclassing API](https://github.com/rust-qt/ritual/issues/26)).

Not planned to support:

- Advanced template usage, like types with integer template arguments.
- Template partial specializations.

## Qt-specific features coverage

- `QFlags<Enum>` types are converted to Rust's own similar implementation located at `qt_core::QFlags`).
- `qt_core` implements a way to use signals and slots. It's possible to use signals and slots of the built-in Qt classes. Rust code can also create slots bound to an arbitrary closure and custom signals. Argument types compatibility is checked at compile time.

## API stability and versioning

Ritual can analyze multiple different versions of the C++ library and generate a crate that supports all of them. Parts of the API that are common across versions are guaranteed to have the same Rust API as well. For parts of the API that are not always available, the Rust bindings will have feature attributes that only enable them if the current local version of the C++ library has them. Trying to use a feature not available in the installed version of C++ library will result in a compile-time error.

When a new version of the C++ library is released, ritual can preserve all existing API in the generated crate and add newly introduced API items under a feature flag. This allows to make semver-compatible changes to the generated crate to support all available versions of the C++ library. 

## Managing dependencies

C++, like most languages, allows libraries to use types from other libraries in their public API. When Rust bindings are generated, they should ideally reuse common dependencies instead of producing a copy of wrappers in each crate. Ritual supports exporting types from already processed dependencies and using them in the public API. 

If a ritual-based crate is published on `crates.io` and you want to use it as a dependency when generating your own bindings, ritual can export the information from it as well. This allows independent developers to base upon each other's work instead of repeating it. 

In addition to Qt crates, ritual project provides the `cpp_std` crate that provides access to C++'s standard library types. It should be used when processing a library that uses STL types in its API. However, `cpp_std` is still in early development and only provides access to a small part of the standard library.

## Platform support

Linux, macOS, and Windows are supported. `ritual` and Qt crates are [continuously tested on Travis](https://travis-ci.com/rust-qt/ritual/branches).

## Safety

It's impossible to bring Rust's safety to C++ APIs automatically, so most of the generated APIs are unsafe to use and require thinking in C++ terms. Most of the generated functions are unsafe because raw pointers are not guaranteed to be valid, and most functions dereference some pointers.

One of intended uses of ritual is to generate a low level interface and then write a safe interface on top of it (which can only be done manually). For huge libraries like Qt, when it's not feasible to design a safe fully-featured API for the whole library, it's recommended to contain unsafe usage in a module and implement a safe interface for the parts of API required for your project. 

## Executable size

Rust crates and C++ wrapper libraries are built statically by default, and the linker only runs once for the final executable that uses the crates. It should be able to eliminate all unused wrapper functions and produce a reasonably small file that will only depend on original C++ libraries.


## How it works

The generator runs in the following steps:

1. If the target library has any dependencies which were already processed and converted to Rust crates, information collected during their generation is loaded from the workspace directory or from `crates.io` and used for further processing.
1. `clang` C++ parser is executed to extract information about the library's types and methods from its header files.
1. The detected methods are checked to filter out invalid parse results.
1. A C++ wrapper library with C-compatible interface is generated. The library exposes each found method using a wrapper function.
1. A Rust code for the crate is generated. Functions from the C++ wrapper library are made available in the crate using Rust's [FFI support](https://doc.rust-lang.org/book/ffi.html). Rust code also contains `struct`s for all found C++ enums, structs and classes (including instantiations of template classes).
1. C++ library documentation (if available) and `ritual`'s processing data are used to generate a full-featured documentation for the crate ([example](https://rust-qt.github.io/rustdoc/qt/qt_core/index.html)).
1. The Rust code is saved to the output directory along with any extra files (tests, examples, etc.) provided by the caller. A build script necessary for building the crate is also attached.
1. Internal information of the generator is written to the database file and can be used when processing the library's dependants.
