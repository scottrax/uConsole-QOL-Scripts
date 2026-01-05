#!/usr/bin/env bash
set -euo pipefail

step="${1:-}"

case "$step" in
  up)
    brightnessctl -q set 10%+
    ;;
  down)
    brightnessctl -q set 10%-
    ;;
  *)
    echo "Usage: $(basename "$0") {up|down}" >&2
    exit 2
    ;;
esac
