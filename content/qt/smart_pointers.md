---
title: Smart pointers
weight: 3
---
Smart pointers are provided by the [cpp_core](https://docs.rs/cpp_core/) crate to make working with C++ objects from Rust easier:

- `CppBox`: owned, non-null (corresponds to C++ objects passed by value or pointers that semantically own the object)
- `Ptr`: possibly owned, possibly null (correspond to C++ pointers)
- `Ref`: not owned, non-null (correspond to C++ references)

Unlike Rust references, these pointers can be freely copied, producing multiple mutable pointers to the same object, which is usually necessary to do when working with C++ libraries.

`qt_core` provide additional special pointers for working with `QObject`:

- `QPtr`: not owned, auto-nullable
- `QBox`: owned unless has a parent, auto-nullable

All these smart pointers have methods for casting (`static_upcast`, `static_downcast`, `dynamic_cast`) and creating iterators (`iter`, `iter_mut`). They also implement operator traits by forwarding to corresponding C++ operators.
