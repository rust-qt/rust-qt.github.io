rust-qt.github.io scripts
=========================

This branch contains scripts for populating [rust-qt.github.io](rust-qt.github.io) web site.
Scripts assume that the following directories are availble in the same directory:

- Clone of [cpp_to_rust](https://github.com/rust-qt/cpp_to_rust) repository (named `cpp_to_rust`);
- Clone of [master branch](https://github.com/rust-qt/rust-qt.github.io/tree/master) of this repository (named `rust-qt.github.io`);
- Clone of [script branch](https://github.com/rust-qt/rust-qt.github.io/tree/script) of this repository (named `rust-qt.github.io_script`).

Call the script like this:

```
cd rust-qt.github.io_script
./update_docs.bash
```
