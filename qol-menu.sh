#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bin_dir="${HOME}/bin"

mkdir -p "$bin_dir"

is_script() {
  local f="$1"
  [[ -f "$f" && -x "$f" && "$f" == *.sh && "$(basename "$f")" != "qol-menu.sh" ]]
}

list_scripts() {
  local f
  while IFS= read -r -d '' f; do
    if is_script "$f"; then
      printf '%s\n' "$f"
    fi
  done < <(find "$repo_dir" -maxdepth 1 -type f -print0)
}

enabled_target() {
  local name="$1"
  local target="$bin_dir/$name"
  if [[ -L "$target" ]]; then
    readlink -f "$target"
  else
    echo ""
  fi
}

enable_script() {
  local src="$1"
  local name
  name="$(basename "$src")"
  ln -sfn "$src" "$bin_dir/$name"
}

disable_script() {
  local name="$1"
  local target="$bin_dir/$name"
  if [[ -L "$target" ]]; then
    rm -f "$target"
  fi
}

status_line() {
  local src="$1"
  local name
  local target
  name="$(basename "$src")"
  target="$(enabled_target "$name")"
  if [[ "$target" == "$src" ]]; then
    printf '%s [enabled]\n' "$name"
  else
    printf '%s [disabled]\n' "$name"
  fi
}

print_menu() {
  echo "uConsole QOL Scripts"
  echo "Repo: $repo_dir"
  echo "Bin:  $bin_dir"
  echo ""
  echo "Scripts:"
  local i=1
  local src
  while IFS= read -r src; do
    printf '  %d) %s' "$i" "$(status_line "$src")"
    i=$((i + 1))
  done < <(list_scripts)
  if [[ $i -eq 1 ]]; then
    echo "  (none found)"
  fi
  echo ""
  echo "Actions:"
  echo "  e <num>  enable"
  echo "  d <num>  disable"
  echo "  a        enable all"
  echo "  x        disable all"
  echo "  r        refresh"
  echo "  q        quit"
}

map_index_to_src() {
  local idx="$1"
  local i=1
  local src
  while IFS= read -r src; do
    if [[ $i -eq $idx ]]; then
      printf '%s\n' "$src"
      return 0
    fi
    i=$((i + 1))
  done < <(list_scripts)
  return 1
}

while true; do
  print_menu
  printf '> '
  read -r action arg || exit 0

  case "$action" in
    e)
      if [[ -z "${arg:-}" ]]; then
        echo "Missing script number."
      else
        src="$(map_index_to_src "$arg" || true)"
        if [[ -n "$src" ]]; then
          enable_script "$src"
          echo "Enabled $(basename "$src")."
        else
          echo "Invalid script number."
        fi
      fi
      ;;
    d)
      if [[ -z "${arg:-}" ]]; then
        echo "Missing script number."
      else
        src="$(map_index_to_src "$arg" || true)"
        if [[ -n "$src" ]]; then
          disable_script "$(basename "$src")"
          echo "Disabled $(basename "$src")."
        else
          echo "Invalid script number."
        fi
      fi
      ;;
    a)
      while IFS= read -r src; do
        enable_script "$src"
      done < <(list_scripts)
      echo "Enabled all scripts."
      ;;
    x)
      while IFS= read -r src; do
        disable_script "$(basename "$src")"
      done < <(list_scripts)
      echo "Disabled all scripts."
      ;;
    r)
      ;;
    q)
      exit 0
      ;;
    *)
      echo "Unknown command."
      ;;
  esac

  echo ""
done
