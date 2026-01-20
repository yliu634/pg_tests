#!/usr/bin/env bash
set -euo pipefail

force=0

usage() {
  cat <<'EOF'
Install repo-vendored Codex skills into $CODEX_HOME/skills (default: ~/.codex/skills)

Usage:
  scripts/install_codex_skills.sh [--force]

Options:
  --force   Overwrite existing installed skill directories
EOF
}

for arg in "$@"; do
  case "$arg" in
    -h|--help)
      usage
      exit 0
      ;;
    --force)
      force=1
      ;;
    *)
      echo "error: unknown arg: $arg" >&2
      usage >&2
      exit 2
      ;;
  esac
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src_root="$repo_root/skills"
codex_home="${CODEX_HOME:-$HOME/.codex}"
dest_root="$codex_home/skills"

if [ ! -d "$src_root" ]; then
  echo "error: skills directory not found: $src_root" >&2
  exit 2
fi

mkdir -p "$dest_root"

installed=0
for skill_dir in "$src_root"/*; do
  [ -d "$skill_dir" ] || continue
  [ -f "$skill_dir/SKILL.md" ] || continue

  skill_name="$(basename "$skill_dir")"
  dest_dir="$dest_root/$skill_name"

  if [ -e "$dest_dir" ]; then
    if [ "$force" -ne 1 ]; then
      echo "error: destination exists: $dest_dir" >&2
      echo "hint: re-run with --force, or remove it manually." >&2
      exit 1
    fi
    rm -rf "$dest_dir"
  fi

  if command -v rsync >/dev/null 2>&1; then
    rsync -a "$skill_dir/" "$dest_dir/"
  else
    mkdir -p "$dest_dir"
    cp -R "$skill_dir/." "$dest_dir/"
  fi

  echo "installed $skill_name -> $dest_dir"
  installed=$((installed + 1))
done

if [ "$installed" -eq 0 ]; then
  echo "error: no skills found under $src_root" >&2
  exit 2
fi

echo "done. restart Codex to pick up new skills."
