# Track Specification: Phase 3a - Baseline Benchmark & NVMe-oF Connection

## Context
With the eBPF foundation (Phase 1) and SPDK environment (Phase 2) established, we now move to Phase 3: The Thesis Project. Before implementing the advanced eBPF offload, we must establish a "control group" or baseline. We need to measure how a standard, non-offloaded application performs when reading data from our SPDK-backed NVMe drive. This track focuses on building that baseline application, establishing the network connection (NVMe over Fabrics) between the kernel and our simulated drive, and recording the initial performance metrics.

## Goals
1.  **Baseline Application:** specific C program that reads a file and counts "Alpha" substrings.
2.  **Data Generation:** A script to generate a verifiable dataset (text file).
3.  **NVMe-oF Connection:** Configure the SPDK Target to expose a namespace and connect the Linux Kernel to it using the native NVMe-oF initiator.
4.  **Benchmark:** Execute the baseline application against the mounted SPDK drive and record the execution time and bus traffic (simulated or inferred).

## Requirements
-   **Existing SPDK Setup:** From Phase 2.
-   **Tools:** `nvme-cli` (for connecting to the target), `fio` (optional, but good for sanity checks), `gcc`.
-   **Kernel Modules:** `nvme`, `nvme-rdma` or `nvme-tcp` (depending on transport, we'll likely use TCP for ease of simulation in userspace).

## Success Criteria
-   `baseline.c` compiles and correctly counts "Alpha" in a test file.
-   SPDK `nvmf_tgt` is configured with a subsystem and namespace.
-   The host kernel sees a new block device (e.g., `/dev/nvme0n1`) provided by SPDK.
-   The baseline application can read from this block device (after mounting or raw read).
-   A `baseline_results.md` file is created with the performance numbers.
