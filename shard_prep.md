# Shard Preparation

- Source todo list: `pg_tests/todo.txt`
- Total files remaining: 452
- Shard size: 50 files per shard
- Shards directory: `pg_tests/shards/`
- Number of shards: 10
- Split command:
  - `split -l 50 -d pg_tests/todo.txt pg_tests/shards/shard_ --additional-suffix=.txt`

## Shards

| Shard file | Entries |
| --- | ---: |
| `shard_00.txt` | 50 |
| `shard_01.txt` | 50 |
| `shard_02.txt` | 50 |
| `shard_03.txt` | 50 |
| `shard_04.txt` | 50 |
| `shard_05.txt` | 50 |
| `shard_06.txt` | 50 |
| `shard_07.txt` | 50 |
| `shard_08.txt` | 50 |
| `shard_09.txt` | 2 |

## Integrity

- Total entries across shards: 452
- Unique entries across shards: 452
- Duplicate entries across shards: 0

Ready for parallel processing.
