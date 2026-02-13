# hello_eBPF

A foundational project for exploring eBPF (Extended Berkeley Packet Filter) on Linux, specifically focusing on its application in Computational Storage and NVMe Offloading.

This project implements the roadmap from "zero" to running code on a simulated NVMe drive, mirroring the path to implementing standard TP4091.

## Current Status: Phase 3a Complete (Baseline Benchmark)
We have successfully established the "Control Group" and the NVMe-oF connection.
- **Baseline App:** A standard C application (`benchmarks/baseline`) is ready to measure standard read performance.
- **NVMe-oF Connection:** Scripts are in place to connect the Linux Kernel to the SPDK target via TCP loopback.
- **Data Generation:** Tools to generate verifiable test datasets.

## Architecture: NVMe over Fabrics & eBPF
Our simulated environment uses NVMe over Fabrics (TCP) to route storage traffic through the kernel's networking stack. This allows us to use standard networking eBPF hooks to intercept storage commands.

```ascii
+-----------------------------------------------------------------------+
|                          HOST (Linux Kernel)                          |
|                                                                       |
|   +-------------+       +-------------+       +-------------+         |
|   | Application |<----->| File System |<----->| Block Layer |         |
|   | (baseline)  |       |   (ext4)    |       | (/dev/nvme) |         |
|   +-------------+       +-------------+       +------+------+         |
|                                                      |                |
|                                              +-------v--------+       |
|                                              |   NVMe TCP     |       |
|                                              |    Driver      |       |
|                                              +-------+--------+       |
|                                                      |                |
|         [eBPF Hook Point] <------------------+-------v--------+       |
|    (Traffic Inspection/Filter)               |  TCP/IP Stack  |       |
|                                              +-------+--------+       |
|                                                      |                |
|                                                (Loopback lo)          |
+------------------------------------------------------|----------------+
                                                       |
                                             +---------v---------+
                                             |  SPDK NVMe Target |
                                             |   (User Space)    |
                                             |  [Fake Hardware]  |
                                             +-------------------+
```

## Roadmap
- [x] **Phase 1: The "Hello World" of eBPF:** Establish the toolchain and run a basic kernel tracepoint.
- [x] **Phase 2: Build the "Fake" Hardware:** Compile SPDK and run a virtual NVMe controller.
- [x] **Phase 3a: Baseline Benchmark:** Implement standard app and NVMe-oF connection.
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

### NVMe-oF Emulation Mechanism
The project utilizes the Linux kernel's `nvme-tcp` module to initiate a connection to the user-space SPDK target. Upon connection, the kernel instantiates a standard block device (e.g., `/dev/nvme0n1`). I/O requests to this device are encapsulated as NVMe commands within TCP packets and transmitted over the loopback interface. The SPDK target receives these commands and executes them against a malloc-backed namespace (RAM drive), enabling high-performance storage simulation without physical NVMe hardware.

## License
Dual BSD/GPL (Inherited from libbpf-bootstrap).
