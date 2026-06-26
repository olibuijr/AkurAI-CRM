#!/usr/bin/env bash
set -euo pipefail
VERSION=$(cat VERSION)
echo "akurai-crm v$VERSION release"
# Quality gate
cargo fmt --check
cargo clippy -D warnings
cargo test --all
echo "✓ All checks passed"
