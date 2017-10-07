#!/bin/bash

set -e

REPO=$(readlink -f $(dirname "$0")/../rust-qt.github.io)

echo "Documenting cpp_to_rust crates..."
cd cpp_to_rust_all
cargo update
cargo doc
OUT_DIR=$REPO/rustdoc/cpp_to_rust
echo "Copying documentation of selected crates..."
mkdir -p "$OUT_DIR"
rm -rf "$OUT_DIR"/*
mkdir "$OUT_DIR/src"

find target/doc/* -maxdepth 0 -type f -exec cp {} "$OUT_DIR/" \;

grep  "var searchIndex\|initSearch\|searchIndex\[\"\(cpp_to_rust_generator\|cpp_to_rust_common\|cpp_to_rust_build_tools\|qt_generator_common\)\"\]" target/doc/search-index.js > "$OUT_DIR/search-index.js"
cp -r target/doc/{cpp_to_rust_generator,cpp_to_rust_common,cpp_to_rust_build_tools,cpp_utils,qt_generator_common} "$OUT_DIR/"
cp -r target/doc/src/{cpp_to_rust_generator,cpp_to_rust_common,cpp_to_rust_build_tools,cpp_utils,qt_generator_common} "$OUT_DIR/src/"

cd ../qt_all
echo "Documenting Qt crates..."
cargo update
cargo doc -j2
OUT_DIR=$REPO/rustdoc/qt

echo "Copying documentation of selected crates..."
mkdir -p "$OUT_DIR"
rm -rf "$OUT_DIR"/*
mkdir "$OUT_DIR/src"

find target/doc/* -maxdepth 0 -type f -exec cp {} "$OUT_DIR/" \;

grep  "var searchIndex\|initSearch\|searchIndex\[\"\(cpp_utils\|qt_core\|qt_gui\|qt_widgets\|qt_ui_tools\|qt_3d_core\|qt_3d_render\|qt_3d_input\|qt_3d_logic\|qt_3d_extras\)\"\]" target/doc/search-index.js > "$OUT_DIR/search-index.js"
cp -r target/doc/{cpp_utils,qt_core,qt_gui,qt_widgets,qt_ui_tools,qt_3d_core,qt_3d_render,qt_3d_input,qt_3d_logic,qt_3d_extras} "$OUT_DIR/"
cp -r target/doc/src/{cpp_utils,qt_core,qt_gui,qt_widgets,qt_ui_tools,qt_3d_core,qt_3d_render,qt_3d_input,qt_3d_logic,qt_3d_extras} "$OUT_DIR/src/"

echo "Publishing changes..."
cd "$REPO"
git add .
git commit -q -a -m "automatic update"
git push
