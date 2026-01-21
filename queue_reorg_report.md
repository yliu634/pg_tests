# Queue Reorganization Report

Files separated by size (500 lines threshold):

- Large files (≥500 lines): 39
- Regular files (<500 lines): 161
- Total remaining: 200

Processing order:
1. Process large files first (fewer per worker, 1-2 files)
2. Process regular files after (standard 5 files per worker)
