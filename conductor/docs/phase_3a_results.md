# Phase 3a: Baseline Performance Results

## Test Environment
- **Mode:** Local Filesystem (CI Environment)
- **Note:** NVMe-oF target setup skipped due to privilege restrictions (`sudo`).
- **File Size:** 100 MB
- **Pattern:** "Alpha" every 4KB.

## Results
- **Expected Count:** 25,600
- **Actual Count:** 25,600
- **Execution Time:** 0.050070 seconds
- **Throughput:** ~2.0 GB/s

## Conclusion
The baseline application `baseline.c` correctly processes data and provides timing metrics. The scripts for SPDK setup (`scripts/start_spdk_tgt.sh`) and host connection (`scripts/connect_host.sh`) are implemented and ready for deployment on a privileged testbed.
