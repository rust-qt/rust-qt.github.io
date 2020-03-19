---
title: Getting started
weight: 2
---
To use Qt from Rust, add the crates as dependencies to your `Cargo.toml`, for example:

```ini
[dependencies]
qt_widgets = "0.2"
```

Each crate re-exports its dependencies, so, for example, you can access `qt_core` as `qt_widgets::qt_core` without adding an explicit dependency.

You can look at the examples in this repository to see how to use the API.

Most of the Qt API is translated to Rust as-is (only modified according to Rust's identifier naming convention), so you can address the Qt documentation for information on it. However, Rust crates provide some additional helpers.

Qt application objects (`QApplication`, `QGuiApplication`, `QCoreApplication`) require `argc` and `argv` to be present, and these are not available directly in Rust. Use `init` helpers to initialize the application correctly:
```rust
fn main() {
    QApplication::init(|app| unsafe {
        //...
    })
}
```

`qt_core` provides API for using signals and slots conveniently. You can connect built-in signals to built-in slots like this:
```rust
let mut timer = QTimer::new_0a();
timer.timeout().connect(app.slot_quit());
```

You can also connect signals to Rust closures (see [form example](src/bin/form1.rs):
```rust
let button_clicked = Slot::new(move || { ... });
button.clicked().connect(&button_clicked);
```
Compatibility of signal's and slot's arguments is checked at compile time.

`QString::from_std_str`, `QString::to_std_string`, `QByteArray::from_slice`, and `impl<'a> From<&'a QString> for String` provide conversions from Qt's types to Rust types and back.

`QFlags` generic type mimics the functionality of C++'s `QFlags` class.

`qdebug` function from `qt_core` wraps a printable (with `QDebug`) Qt object into a shim object that implements Rust's `fmt::Debug`.
