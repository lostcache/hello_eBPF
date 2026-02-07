# Environment Setup & External Steps

This file documents all non-coding steps required to set up the development environment, install system-level dependencies, and configure external tools.

---

## 2026-02-07: Initial Toolchain & Scaffolding Setup

### System Dependencies
The following packages were installed on Ubuntu 24.04 (Noble) to support eBPF development:

```bash
sudo apt-get update
sudo apt-get install -y clang llvm make libelf-dev zlib1g-dev linux-tools-common linux-tools-generic pkg-config gcc
```

**Note:** `bpftool` is provided by `linux-tools-generic` (or kernel-specific tools packages) on Ubuntu.

### Scaffolding
The project structure was initialized using `libbpf-bootstrap`:

1.  Cloned `libbpf-bootstrap` (with submodules).
2.  Extracted files to the project root.
3.  Correctly registered submodules (`libbpf`, `bpftool`, `blazesym`, `vmlinux.h`) in `.gitmodules`.
4.  Verified the build by running `make` in `examples/c`.

### Verification
Dependency status was verified using `./test/verify_deps.sh`:
- Clang, LLVM-strip, Make, Bpftool, Pkg-config: OK
- libelf, zlib headers: OK
