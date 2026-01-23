## Round 1 Complete
- Date: Wed Jan 21 10:27:23 UTC 2026
- Files processed: 100
- Workers merged (detected): 8
- Files processed (merged reports): 40
- Successful: 38
- Failed: 2
- Remaining in queue: 357
## Round 1 Complete
- Date: Wed Jan 21 10:42:49 UTC 2026
- Workers launched: 20
- New expected files generated: 21
- Remaining in todo queue: 357

## Round 1 Merge Update
- Date: Wed Jan 21 11:02:00 UTC 2026
- Added expected files (with matching sql) from other origin branches: 38
- Remaining Round 1 manifest expected missing: 4 (see failures.txt)

## Round 2 Complete
- Date: Wed Jan 21 12:50:37 UTC 2026
- Workers: 20
- New expected files: 63
- Remaining in todo.txt: 200

## Final Completion Analysis
- Date: Thu Jan 22 14:15:17 UTC 2026
- Total SQL files: 457
- Baseline .expected files: 122
- Total .expected files (compatible/): 451
- New .expected files generated: 329
- Successfully completed (no ERROR in .expected): 405
- Files with ERROR remaining: 46
- Missing .expected files: 6 (txn, udf, udf_fk, udf_params, upsert, vector_index)
- Status: INCOMPLETE (see merge_incomplete_small_results.md)

Round Missing-6 prepared: 6 files

## Round Missing-6 Merge Results
- Date: Fri Jan 23 07:44:09 UTC 2026
- Target set: 6 (txn, udf, udf_fk, udf_params, upsert, vector_index)
- Newly generated .expected: 4 (txn, udf, udf_fk, udf_params)
- Still missing .expected: 2 (upsert, vector_index) (see missing_still.txt)
- Total SQL files: 457
- Total .expected files (compatible/): 455
- Successfully completed (no ERROR in .expected): 409
- Files with ERROR in .expected: 46
- Missing .expected files: 2
- Success rate: 89.50%
- Status: INCOMPLETE (upsert/vector_index outstanding)
