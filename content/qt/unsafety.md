---
title: Unsafety
weight: 4
---
It's impossible to bring Rust's safety to C++ APIs automatically, so most of the generated APIs are unsafe to use and require thinking in C++ terms. Most of the generated functions are unsafe because raw pointers are not guaranteed to be valid, and most functions dereference some pointers.

It's recommended to contain unsafe usage in a module and implement a safe interface for the parts of API required for your project.

You should be careful when working with Qt objects. Qt has its own [ownership system](https://doc.qt.io/qt-5/objecttrees.html) that must be respected. If you retain a pointer to an object owned by another object, it can be deleted and you may produce undefined behavior when trying to access the deleted object.

On the other hand, C++ doesn't require mutable access to be exclusive, so it's sometimes allowed to mutate an object while there are other mutable pointers to it. Smart pointer types provided by ritual allow you to do that conveniently.
