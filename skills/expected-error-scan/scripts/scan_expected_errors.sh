#!/usr/bin/env bash
set -euo pipefail

root_dir="${1:-compatible}"
pattern="${2:-psql:.* ERROR:}"

if [ ! -d "$root_dir" ]; then
  echo "Root directory not found: $root_dir" >&2
  exit 1
fi

found=0

while IFS= read -r -d '' file; do
  if grep -Eq "$pattern" "$file"; then
    found=1
    out_file="${file%.expected}.txt"
    {
      echo "source: $file"
      echo "pattern: $pattern"
      echo "matches:"
      awk -v pat="$pattern" '
        $0 ~ pat {
          printf "line %d: %s\n", NR, $0
          if (getline nextline) {
            if (nextline ~ /^STATEMENT:/) {
              printf "line %d: %s\n", NR+1, nextline
            }
          }
        }
      ' "$file"
    } > "$out_file"
  fi
done < <(find "$root_dir" -name "*.expected" -print0)

if [ "$found" -eq 0 ]; then
  echo "No matches for pattern in $root_dir"
fi
