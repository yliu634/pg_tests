#!/usr/bin/env bash
set -euo pipefail

PG_DB="${PG_DB:-crdb_tests}"
PG_USER="${PG_USER:-${USER:-$(id -un)}}"
PG_HOST="${PG_HOST:-localhost}"
PG_PORT="${PG_PORT:-5432}"
PG_ADMIN_DB="${PG_ADMIN_DB:-template1}"
PG_SUDO_USER="${PG_SUDO_USER:-}"

# Optional: run psql as a different OS user (e.g. postgres) to leverage local peer auth.
PSQL=(psql)
if [ -n "$PG_SUDO_USER" ]; then
  PSQL=(sudo -n -u "$PG_SUDO_USER" psql)
fi

usage() {
  cat <<'EOF'
regen_expected.sh: run SQL file(s) on PostgreSQL and write matching .expected output(s)

Usage:
  regen_expected.sh compatible/foo.sql [compatible/bar.sql ...]

Env (optional):
  PG_DB        Base db name/prefix (default: crdb_tests)
  PG_USER      Postgres user (default: $USER)
  PG_HOST      Postgres host (default: localhost)
  PG_PORT      Postgres port (default: 5432)
  PG_ADMIN_DB  Admin db for create/drop (default: template1)
  PG_SUDO_USER Run psql under this OS user (default: unset)
EOF
}

die() {
  echo "error: $*" >&2
  exit 2
}

psql_admin() {
  "${PSQL[@]}" -X -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_ADMIN_DB" "$@"
}

psql_db() {
  local db="$1"
  shift
  "${PSQL[@]}" -X -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$db" "$@"
}

run_one() (
  local sql_file="$1"
  local test_name expected_file test_db tmp_output

  [ -f "$sql_file" ] || die "SQL file not found: $sql_file"
  [[ "$sql_file" == *.sql ]] || die "not a .sql file: $sql_file"

  expected_file="${sql_file%.sql}.expected"
  test_name="$(basename "$sql_file" .sql)"
  test_db="${PG_DB}_${test_name//[^a-zA-Z0-9]/_}"
  test_db="${test_db:0:63}"
  tmp_output="$(mktemp)"

  cleanup() {
    if [ -n "${test_db:-}" ]; then
      psql_admin -v ON_ERROR_STOP=1 -c "DROP DATABASE IF EXISTS \"$test_db\";" >/dev/null 2>&1 || true
    fi
    if [ -n "${tmp_output:-}" ]; then
      rm -f "$tmp_output" >/dev/null 2>&1 || true
    fi
  }
  trap cleanup EXIT

  psql_admin -v ON_ERROR_STOP=1 -c "DROP DATABASE IF EXISTS \"$test_db\";" >/dev/null
  psql_admin -v ON_ERROR_STOP=1 -c "CREATE DATABASE \"$test_db\";" >/dev/null

  if ! psql_db "$test_db" -v ON_ERROR_STOP=1 -f "$sql_file" >"$tmp_output" 2>&1; then
    echo "error: PostgreSQL ERROR while running $sql_file" >&2
    echo "error: (leaving $expected_file unchanged)" >&2
    tail -n 80 "$tmp_output" >&2 || true
    return 1
  fi

  mv "$tmp_output" "$expected_file"
  tmp_output=""
  echo "wrote $expected_file"
)

main() {
  if [ $# -eq 0 ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
    usage
    exit 0
  fi

  for sql_file in "$@"; do
    run_one "$sql_file"
  done
}

main "$@"
