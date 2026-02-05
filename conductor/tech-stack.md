# Technology Stack

## Core Development
- **Language:** C (Standard C99/C11)
- **Compiler:** Clang/LLVM (Required for BPF backend support)
- **Build System:** Make / CMake (Standard for SPDK and BPF projects)

## eBPF Ecosystem
- **Library:** libbpf (Standard modern BPF library)
- **Tooling:** bpftool (Introspection and debugging), libbpf-bootstrap (Project scaffolding)

## Storage & Virtualization
- **Storage Kit:** SPDK (Storage Performance Development Kit) - For implementing the user-space NVMe target.
- **Emulator:** QEMU - For simulating the host machine and hardware devices.
- **Protocol:** NVMe over Fabrics (NVMe-oF) - To allow the emulated host to communicate with the SPDK target.

## Environment
- **OS:** Linux (Recent kernel 5.15+ recommended for full eBPF feature support)
