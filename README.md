# hello_eBPF

A foundational project for exploring eBPF (Extended Berkeley Packet Filter) on Linux, specifically focusing on its application in Computational Storage and NVMe Offloading.

This project implements the roadmap from "zero" to running code on a simulated NVMe drive, mirroring the path to implementing standard TP4091.

## Current Status: Phase 2 Complete (SPDK Setup & NVMe Simulation)
We have successfully established the "Fake Hardware" environment.
- **eBPF Environment:** Fully configured with `libbpf`, `clang`, and `bpftool`.
- **NVMe Simulation:** SPDK (Storage Performance Development Kit) is built and configured.
- **Target Status:** The user-space NVMe target (`nvmf_tgt`) runs and accepts RPC commands.

## Roadmap
- [x] **Phase 1: The "Hello World" of eBPF:** Establish the toolchain and run a basic kernel tracepoint.
- [x] **Phase 2: Build the "Fake" Hardware:** Compile SPDK and run a virtual NVMe controller.
- [ ] **Phase 3: TP4091 Command Implementation:** Implement the custom "Load Program" command in SPDK.
- [ ] **Phase 4: The "Thesis" Project:** Offload eBPF logic to the simulated drive to filter data at the source.

## Getting Started

### 1. Prerequisites
- **OS:** Linux (Ubuntu 24.04 Recommended).
- **Privileges:** `sudo` access is required for installing dependencies and allocating hugepages.

### 2. Install Dependencies
To build both the eBPF examples and the SPDK environment:

```bash
# eBPF Toolchain
sudo apt-get update
sudo apt-get install -y clang llvm make libelf-dev zlib1g-dev linux-tools-common linux-tools-generic pkg-config gcc

# SPDK Dependencies (via script)
cd spdk
sudo ./scripts/pkgdep.sh
cd ..
```

### 3. Build the Project
**Build eBPF Examples:**
```bash
cd examples/c
make
cd ../..
```

**Build SPDK (Simulated NVMe):**
```bash
cd spdk
./configure
make -j$(nproc)
cd ..
```

### 4. Configure Hugepages
SPDK requires hugepages for Direct Memory Access (DMA). **You must run this after every reboot.**

```bash
sudo spdk/scripts/setup.sh
```

## Usage

### Running eBPF Examples
The `examples/c` directory contains standard libbpf examples.
```bash
cd examples/c
sudo ./minimal
```
*Check `/sys/kernel/debug/tracing/trace_pipe` to see the output.*

### Running the Simulated NVMe Drive
To start the NVMe Target (which simulates the computational storage drive):

1.  **Start the Target (in one terminal):**
    ```bash
    sudo spdk/build/bin/nvmf_tgt
    ```
    *This process will hang as it acts as the server.*

2.  **Interact via RPC (in another terminal):**
    SPDK uses JSON-RPC for management.
    ```bash
    sudo spdk/scripts/rpc.py spdk_get_version
    ```
    *You should see a JSON response with the SPDK version.*

## Project Structure
- `conductor/`: Project plans, tracks, and technical documentation.
- `spdk/`: The Storage Performance Development Kit (Simulated Hardware).
- `examples/c/`: C-based eBPF examples.
- `libbpf/`: Core BPF library.
- `bpftool/`: BPF inspection tool.

## Technical Context
This project combines **eBPF** (kernel-level sandboxed execution) with **SPDK** (user-space storage drivers) to simulate **Computational Storage**. By running eBPF programs *inside* the SPDK target, we mimic the behavior of next-generation SSDs that can process data directly on the drive, reducing bus traffic and CPU load.

## License
Dual BSD/GPL (Inherited from libbpf-bootstrap).
