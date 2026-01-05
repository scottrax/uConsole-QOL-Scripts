#!/usr/bin/env bash
set -euo pipefail

step="${1:-}"

case "$step" in
  up)
    amixer sset Master 5%+
    ;;
  down)
    amixer sset Master 5%-
    ;;
  *)
    echo "Usage: $(basename "$0") {up|down}" >&2
    exit 2
    ;;
esac
