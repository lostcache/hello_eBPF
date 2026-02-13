# Baseline Benchmark & NVMe-oF Connection

This directory contains the "control group" for our computational storage experiment. Before implementing advanced eBPF offloading, we establish a baseline by measuring the performance of a standard application reading from our simulated NVMe drive.

## Architecture: NVMe over Fabrics (TCP Loopback)

Unlike a physical NVMe drive connected via PCIe, our simulated setup uses **NVMe over Fabrics (NVMe-oF)** over the local TCP loopback interface. This architecture is crucial because it exposes storage traffic to the kernel's networking stack, allowing us to attach **eBPF programs** to inspect or modify storage commands.

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

## Contents

*   **`baseline.c`**: The standard C application. It reads a file in 64KB chunks and counts the occurrences of the string "Alpha".
*   **`Makefile`**: Compiles the baseline application.
*   **`test_baseline.py`**: A unit test to verify the correctness of the baseline application.

## How to Run the Benchmark

The entire workflow involves starting the SPDK target, connecting the host kernel to it, generating data, and running the benchmark.

### 1. Start the SPDK Target
(From the project root)
```bash
./scripts/start_spdk_tgt.sh
```
This configures SPDK with a 64MB RAM-drive and starts listening on `127.0.0.1:4420`.

### 2. Connect the Host
(From the project root)
```bash
./scripts/connect_host.sh
```
This loads the `nvme-tcp` kernel module and connects to the target. You should see a new NVMe device (e.g., `/dev/nvme0n1`).

> **Mechanism:** The kernel `nvme-tcp` driver establishes a TCP connection to the SPDK target. The kernel recognizes the target as a compliant NVMe controller and instantiates a block device (e.g., `/dev/nvme0n1`). I/O operations performed on this device are transparently translated into NVMe-over-TCP commands, transmitted to the SPDK process, and executed against the allocated RAM buffer.

### 3. Generate Test Data
Write 50MB of deterministic test data to the device.
```bash
# Replace /dev/nvme0n1 with your actual device path if different
sudo python3 scripts/generate_data.py /dev/nvme0n1 50
```

### 4. Run the Benchmark
Compile and run the baseline application.
```bash
cd benchmarks
make
sudo ./baseline /dev/nvme0n1
```
The output will show the total count of "Alpha" strings and the execution time.
