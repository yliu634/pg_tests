---
name: expected-error-scan
description: Scan compatible/*.expected outputs for psql error lines and write per-file .txt reports. Use when verifying expected outputs or gathering error summaries without deleting any .expected files.
---

# Expected Error Scan

## Overview

Scan `.expected` files for `psql:* ERROR:` (or a custom pattern) and write a sibling `.txt` report for each file that matches.

## Quick Start

Run the script from the repo root:

```bash
skills/expected-error-scan/scripts/scan_expected_errors.sh
```

## Workflow

1. Run the scan script with optional parameters:

```bash
skills/expected-error-scan/scripts/scan_expected_errors.sh [root_dir] [pattern]
```

- `root_dir` defaults to `compatible`
- `pattern` defaults to `psql:.* ERROR:`

2. Review generated reports:

- For each matching file `compatible/foo.expected`, a report `compatible/foo.txt` is created/overwritten.
- Reports contain the source file, pattern, matching error lines with line numbers, and the `STATEMENT:` line when present.

## Notes

- This skill never deletes or modifies `.expected` files.
- To use a different error pattern, pass it as the second argument.

## Resources

### scripts/

- `scan_expected_errors.sh`: Find matching `.expected` files and generate per-file `.txt` error reports.
