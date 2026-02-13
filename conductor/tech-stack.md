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
- **Protocol:** NVMe over Fabrics (NVMe-oF) - To allow the emulated host to communicate with the SPDK target via TCP/IP.

## Architecture Diagram (NVMe-oF Loopback)
The project utilizes a loopback architecture where the NVMe driver communicates with the SPDK target over the local TCP interface. This exposes storage commands to the kernel's networking stack, enabling eBPF interception.

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

## Environment
- **OS:** Linux (Recent kernel 5.15+ recommended for full eBPF feature support)
