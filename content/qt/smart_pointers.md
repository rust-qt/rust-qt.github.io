---
title: Smart pointers
weight: 3
---
Smart pointers are provided by the [cpp_core](https://docs.rs/cpp_core/0.5.0/cpp_core/) crate to make working with C++ objects from Rust easier:

- `CppBox`: owned, non-null (corresponds to C++ objects passed by value)
- `Ptr` and `MutPtr`: possibly owned, possibly null (correspond to C++ pointers)
- `Ref` and `MutRef`: not owned, non-null (correspond to C++ references)

Unlike Rust references, these pointers can be freely copied, producing multiple mutable pointers to the same object, which is usually necessary to do when working with C++ libraries.

These smart pointers also allow you to use casts, iterators, and operators. 
