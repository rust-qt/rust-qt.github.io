---
title: Ritual
weight: 1
---
`ritual` allows to use C++ libraries from Rust. It analyzes the C++ API of a library and generates a fully-featured crate that provides convenient (but still unsafe) access to this API.

The main motivation for this project is to provide access to Qt from Rust. Ritual provides large amount of automation, supports incremental runs, and implements compatible API evolution. This is mostly dictated by the huge size of API provided by Qt and significant API differences between Qt versions. However, ritual is designed to be universal and can also be used to easily create bindings for other C++ libraries.

## Examples and guides

- [How to use Qt from Rust](/qt)
- [How to use ritual on a C++ library of your choice](/processing_cpp_library)
- [More about ritual](/ritual)

