# hello_eBPF

A foundational project for exploring eBPF (Extended Berkeley Packet Filter) on Linux, starting from environment setup and "Hello World" to complex kernel interactions.

## Current Status: Phase 1 Complete (Environment & Scaffolding)
The development environment is fully established, and the `libbpf-bootstrap` scaffolding is integrated and verified.

## Getting Started

### System Dependencies
To build and run eBPF programs on Ubuntu 24.04 (Noble), the following packages are required:

```bash
sudo apt-get update
sudo apt-get install -y clang llvm make libelf-dev zlib1g-dev linux-tools-common linux-tools-generic pkg-config gcc
```

*Note: `bpftool` is provided by the `linux-tools-generic` package on Ubuntu.*

### Environment Setup
The project uses `libbpf-bootstrap` as its foundational scaffolding. This provides:
- `libbpf`: The core library for interacting with BPF.
- `bpftool`: A tool for inspection and management of BPF programs and maps.
- `vmlinux.h`: BPF CO-RE (Compile Once – Run Everywhere) headers.

To initialize the environment (already completed for this repo):
1.  Cloned `libbpf-bootstrap` with submodules.
2.  Verified the toolchain by building the `minimal` example.

## Verification

You can verify that your system has all necessary dependencies by running the included test script:

```bash
./test/verify_deps.sh
```

### Expected Output:
```text
Checking system dependencies...
✅ clang is installed: ...
✅ llvm-strip is installed: ...
✅ make is installed: ...
✅ bpftool is installed: ...
✅ pkg-config is installed: ...
✅ libelf headers are installed
✅ zlib headers are installed
All dependencies verified successfully.
```

## Building Examples

The project includes several examples in the `examples/c` directory from the bootstrap project. To build them:

```bash
cd examples/c
make
```

### Running "Minimal"
`minimal` installs a tracepoint handler triggered every second. 

```bash
cd examples/c
sudo ./minimal
```

To see the output, read the trace pipe:
```bash
sudo cat /sys/kernel/debug/tracing/trace_pipe
```

## Project Structure
- `conductor/`: Project management, plans, and technical specifications.
- `examples/c/`: C-based eBPF examples and demo applications.
- `libbpf/`: The core libbpf library (submodule).
- `bpftool/`: BPF inspection and management tool (submodule).
- `blazesym/`: Symbolization library for stacktraces (submodule).
- `vmlinux.h/`: BPF CO-RE headers (submodule).
- `test/`: Verification scripts and tests.

## License
Dual BSD/GPL (Inherited from libbpf-bootstrap).