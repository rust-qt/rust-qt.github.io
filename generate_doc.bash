#!/bin/bash

set -e

cd cpp_to_rust_all
cargo doc
REPO=../../rust-qt.github.io
OUT_DIR=$REPO/rustdoc/cpp_to_rust
echo "Copying documentation of selected crates..."
mkdir -p "$OUT_DIR"

find target/doc/* -maxdepth 0 -type f -exec cp {} "$OUT_DIR/" \;

grep  "var searchIndex\|initSearch\|searchIndex\[\"\(cpp_to_rust_generator\|cpp_to_rust_common\|cpp_to_rust_build_tools\|cpp_utils\|qt_build_tools\|qt_generator_common\)\"\]" target/doc/search-index.js > "$OUT_DIR/search-index.js"
cp -r target/doc/{cpp_to_rust_generator,cpp_to_rust_common,cpp_to_rust_build_tools,cpp_utils,qt_build_tools,qt_generator_common} "$OUT_DIR/"

echo "Done"
cd "$REPO"
git add .
git commit -q -a -m "automatic update"
git push
