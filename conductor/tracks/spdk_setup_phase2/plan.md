# Track Plan: Phase 2 - SPDK Setup

## Tasks

- [x] Clone SPDK Repository 44e0ee7
  - **Goal:** Get the SPDK source code.
  - **Details:** Clone `https://github.com/spdk/spdk` into the project root. Initialize submodules.
  - **Verification:** Directory `spdk` exists and contains source files.

- [ ] Install SPDK Dependencies
  - **Goal:** Ensure system has required libraries.
  - **Details:** Run `spdk/scripts/pkgdep.sh` to install dependencies.
  - **Verification:** Script completes successfully.

- [ ] Build SPDK
  - **Goal:** Compile the toolkit.
  - **Details:** Run `./configure` and `make` inside the `spdk` directory.
  - **Verification:** `build/bin/nvmf_tgt` executable exists.

- [ ] Configure System (Hugepages)
  - **Goal:** Reserve memory for SPDK.
  - **Details:** Run `spdk/scripts/setup.sh`.
  - **Verification:** Script indicates hugepages are allocated.

- [ ] Verify NVMe Target
  - **Goal:** Confirm the target runs and responds to RPCs.
  - **Details:** Start `nvmf_tgt` in the background. Run `scripts/rpc.py spdk_get_version` to check connectivity. Kill the background process afterwards.
  - **Verification:** Version information is printed to stdout.
