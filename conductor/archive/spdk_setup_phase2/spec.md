# Track Specification: Phase 2 - SPDK Setup & NVMe Simulation

## Context
Following the successful establishment of the eBPF foundation (Phase 1), the next critical step in our roadmap is to build the "Fake Hardware" environment. We need a simulated NVMe controller that can accept custom commands, which is a prerequisite for implementing the TP4091 offloading standard later. We will use SPDK (Storage Performance Development Kit) for this purpose, as it provides a user-space NVMe target (`nvmf_tgt`) that is highly extensible.

## Goals
1.  **Environment Preparation:** Install all necessary system dependencies for SPDK (including hugepage support).
2.  **SPDK Installation:** Clone and build the SPDK codebase from source.
3.  **Target Execution:** Successfully run the `nvmf_tgt` (NVMe over Fabrics Target) application.
4.  **Verification:** Verify the target is running and responsive by using SPDK's RPC interface to query its subsystem status.

## Requirements
-   **OS:** Linux (as defined in tech-stack).
-   **Source:** SPDK GitHub repository (latest stable or master).
-   **System Resources:** Hugepages must be reserved (SPDK requires this for DMA).
-   **Tools:** `make`, `gcc`/`clang`, `python3` (for RPC scripts).

## Success Criteria
-   SPDK compiles without errors.
-   The `setup.sh` script successfully allocates hugepages.
-   `nvmf_tgt` starts and binds to a local address/socket.
-   `scripts/rpc.py spdk_get_version` (or similar) returns a valid response from the running target.
