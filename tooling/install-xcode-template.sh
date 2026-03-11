#!/usr/bin/env sh

set -eu

XCODE_TEMPLATE_DIR="$HOME/Library/Developer/Xcode/Templates/File Templates/RIBs"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

xcodeTemplate() {
  echo "==> Copying RIBsArchitecture Xcode file templates..."

  if [ -d "$XCODE_TEMPLATE_DIR" ]; then
    rm -rf "$XCODE_TEMPLATE_DIR"
  fi
  mkdir -p "$XCODE_TEMPLATE_DIR"

  cp -R "$SCRIPT_DIR"/*.xctemplate "$XCODE_TEMPLATE_DIR"
}

xcodeTemplate

echo "==> ... success!"
echo "==> Templates installed. In Xcode, select 'New File...' to use RIBsArchitecture templates."
