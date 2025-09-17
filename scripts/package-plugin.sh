#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGINDIR="$ROOT_DIR/plugin/local/brainsait"
OUTDIR="$ROOT_DIR/dist"
PKGNAME="local_brainsait_$(date +%Y%m%d%H%M%S).zip"

mkdir -p "$OUTDIR"
cd "$PLUGINDIR/.."
zip -r "$OUTDIR/$PKGNAME" "brainsait" -x "**/.DS_Store" "**/.git*" "**/__pycache__/*"
echo "Created plugin package: $OUTDIR/$PKGNAME"
