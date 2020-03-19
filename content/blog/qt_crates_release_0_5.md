---
title: "Qt crates release 0.5"
date: 2020-03-19
---
New features:

<!--more-->

- Qt 5.14 is now supported.
- It's now possible to create and emit signals:
```rust
use qt_core::{QTimer, SignalOfInt};
let signal = SignalOfInt::new();
let timer = QTimer::new_0a();
signal.connect(timer.slot_start());
signal.emit(100);
```
- Slot wrappers can now have a parent object, so they can be kept alive without storing them explicitly.
- New smart pointers [QPtr](https://docs.rs/qt_core/0.5.0-alpha.2/qt_core/struct.QPtr.html) and [QBox](https://docs.rs/qt_core/0.5.0-alpha.2/qt_core/struct.QBox.html) are added. Functions that return `QObject`-based objects now use `QPtr` and `QBox` in their return types. These pointers automatically become null when the referenced object is deleted. This prevents many cases of accidental use-after-free:
```rust
let obj = QObject::new_0a();
let obj2 = QObject::new_1a(&obj);
assert!(!obj2.is_null());
// When obj is deleted, it deletes its child obj2.
drop(obj);
// obj2 pointer automatically becomes null.
assert!(obj2.is_null());
```
- `QBox` deletes the object on drop (like `CppBox`) but only if it has no parent. In previous versions, `CppBox` required users to use `into_ptr()` or similar methods to avoid deletion of temporary objects. Now just implicitly setting the parent is enough:
```rust
let widget = QWidget::new_0a();
let layout = QVBoxLayout::new_1a(&widget);
let line_edit = QLineEdit::new();
layout.add_widget(&line_edit);
// layout and line_edit now have a parent,
// so QBox won't delete them at the end of scope.
```
- Rust wrappers for C++ class methods now always require `&self`, regardless of C++ constness. This behavior better matches the Rust semantics of references (exclusive access is generally not required for calling these methods) and ensures better interaction with the borrow checker.
- It's now possible to embed [Qt resources](https://doc.qt.io/qt-5/resources.html) into executables using [qt_ritual_build::add_resources](https://docs.rs/qt_ritual_build/0.5.0-alpha.1/qt_ritual_build/fn.add_resources.html) and [qt_core::q_init_resource](https://docs.rs/qt_core/0.5.0-alpha.2/qt_core/macro.q_init_resource.html).
- New [qt_core::slot](https://docs.rs/qt_core/0.5.0-alpha.2/qt_core/attr.slot.html) attribute macro provides a convenient way to use struct methods as slots.
- [qt_ui_tools::ui_form](https://docs.rs/qt_ui_tools/0.5.0-alpha.2/qt_ui_tools/attr.ui_form.html) attribute macro simplifies loading a UI form file and accessing its objects.
- It's now possible to choose connection type using [Signal::connect_with_type](https://docs.rs/qt_core/0.5.0-alpha.2/qt_core/struct.Signal.html#method.connect_with_type) function.
- It's now possible to check if the connection was successful using [Connection::is_valid](https://docs.rs/qt_core/0.5.0-alpha.2/qt_core/q_meta_object/struct.Connection.html#method.is_valid).

Migration notes:

- `cpp_core::{MutPtr, MutRef}` are removed. `Ptr` and `Ref` should be used instead. The same applies to methods that used to return `MutPtr` and `MutRef` (e.g. `CppBox::as_mut_ptr` is removed and `CppBox::as_ptr` should be used instead).
- Raw slot wrappers (e.g. `qt_core::RawSlotOfQObject`) are removed. Main slot wrappers (e.g. `qt_core::qt_core::SlotOfQObject`) should be used instead.
- Slot wrappers now require closures to be `'static`, so they cannot have any references to temporary values.
- `new()` function of slot wrappers now require a new `parent` argument. If no parent is needed, `cpp_core::NullPtr` can be passed instead.
- `clear()` function of slot wrappers is removed. Use `set()` with an empty closure instead.
- `qt_core::Slot` is renamed to `SlotNoArgs`.
- `Ptr` and `Ref` smart pointers are now only used for class objects. All other pointers and references are now represented as raw pointers in Rust.
- `cpp_core::SliceAsBeginEnd` is reworked into `cpp_core::EndPtr`.
 
