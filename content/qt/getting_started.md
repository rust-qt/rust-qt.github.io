---
title: Getting started
weight: 2
---
To use Qt from Rust, add the crates as dependencies to your `Cargo.toml`, for example:

```ini
[dependencies]
qt_widgets = "0.5"
```

Each crate re-exports its dependencies, so, for example, you can access `qt_core` as `qt_widgets::qt_core` without adding an explicit dependency. You can also add them as direct dependencies for convenience, but make sure to use compatible versions.

See [rust-qt/examples](https://github.com/rust-qt/examples) repository to see how to use the API provided by Qt crates.

Most of the Qt API is translated to Rust as-is when possible. Identifiers are modified according to Rust's naming convention. Overloaded methods (methods accepting multiple sets of argument types) are wrapped as distinct Rust methods with suffixes that distinguish between them.

In many cases, you can address the Qt documentation and translate examples from it almost directly to Rust code. Crate documentation (available on [docs.rs](https://docs.rs/qt_core/) or through `cargo doc`) features embedded Qt documentation.

In addition, Rust crates provide some helpers to improve ergonomics:

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

You can also connect signals to Rust closures (see [basic_form example](https://github.com/rust-qt/examples/blob/master/widgets/basic_form/src/main.rs):
```rust
let button_clicked = SlotNoArgs::new(NullPtr, move || { ... });
button.clicked().connect(&button_clicked);
```

You can also create and emit signals:
```rust
use qt_core::{QTimer, SignalOfInt};
let signal = SignalOfInt::new();
let timer = QTimer::new_0a();
signal.connect(timer.slot_start());
signal.emit(100);
```

Compatibility of signal's and slot's arguments is checked at compile time.

Note that each set of argument types requires a separate Rust type of signal or slot (e.g. `SlotNoArgs`, `SlotOfInt`, etc.). Other crates may also provide new signal and slot objects (e.g. `qt_widgets::SlotOfQTreeWidgetItem`).

`QString::from_std_str`, `QString::to_std_string`, `QByteArray::from_slice`, and `impl<'a> From<&'a QString> for String` provide conversions from Qt's types to Rust types and back.

`QFlags` generic type mimics the functionality of C++'s `QFlags` class.

`qdbg` function from `qt_core` wraps a printable (with `QDebug`) Qt object into a shim object that implements Rust's `fmt::Debug`.
