#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${LABWC_PID:-}" ]]; then
  echo "LABWC_PID is not set. Run this from your labwc session." >&2
  exit 1
fi

labwc --reconfigure
