# Retry Analysis Report

## Failure Sources
- From failures.txt: 6
- From failed workers (00, 04, 15, 19): 7
- Total unique failures: 13

## Retry Queue
- Files needing retry: 10
- Large files (≥500 lines): 10
- Small files (<500 lines): 0

## Next Actions
- Retry large files with 1-2 per worker
- Retry small files with 5 per worker
