#!/usr/bin/env bash
set -e

INSTALL_DIR="${CGO_INSTALL_DIR:-$HOME/.local/bin}"

echo "  Installing cgo → $INSTALL_DIR/cgo"
mkdir -p "$INSTALL_DIR"
cp "$(dirname "$0")/cgo" "$INSTALL_DIR/cgo"
chmod +x "$INSTALL_DIR/cgo"

# Check PATH
if ! echo "$PATH" | tr ':' '\n' | grep -qx "$INSTALL_DIR"; then
  echo ""
  echo "  ⚠  $INSTALL_DIR is not on your PATH."
  echo "  Add this to your ~/.zshrc or ~/.bashrc:"
  echo ""
  echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo ""
fi

echo "  Done. Run: cgo"
