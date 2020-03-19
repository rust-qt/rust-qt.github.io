---
title: Running generator
weight: 2
---
Note: as described above, it's recommended to use docker for creating a suitable environment.

The generator itself (`ritual`) is a library which exposes API for configurating different aspects of the process. In order to run the generator and produce an output crate, one must use a binary crate (such as `qt_ritual`) and launch the generator using its API.

Qt crates can be generated like this:
```bash
cd ritual
cargo run --release --bin qt_ritual -- /path/to/workspace -c qt_core -o main
```

The workspace directory will be used for storing databases, temporary files, and the generated crates. Use the same workspace directory for all Qt crates to make sure that ritual can use types from previously generated crates.

Similarly, this is how `cpp_std` can be generated:
```bash
cargo run --release --bin std_ritual -- /path/to/workspace -c cpp_std -o main
```
