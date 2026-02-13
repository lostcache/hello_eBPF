# Initial Concept

✦ This is a "bleeding edge" area. Because the standard (TP4091) was only ratified in 2024, there are no polished "Hello World" tutorials yet.

  To get started, you have to build your own development lab using emulators (since you likely cannot buy this hardware yet).

  Here is the 3-step roadmap to go from "zero" to "running code on a fake NVMe drive."

  Phase 1: The "Hello World" of eBPF
  Before you run code on a hard drive, you must learn to run it in the Linux kernel.
   1. Goal: Write a C program that counts network packets or file reads.
   2. Tools: clang, llvm, libbpf (The modern standard library for eBPF).
   3. Action:
       * Install the BCC (BPF Compiler Collection) tools on your Linux machine (or VM).
       * Follow the libbpf-bootstrap (https://github.com/libbpf/libbpf-bootstrap) guide. This is currently the gold standard for starting a new eBPF project.
       * Why? The code you write here (restricted C) is exactly what you will eventually push to the NVMe controller.

  Phase 2: Build the "Fake" Hardware (QEMU + SPDK)
  Since you don't have a Computational SSD, you need to simulate one.
   1. Goal: Create a virtual NVMe drive that accepts custom commands.
   2. Tools: QEMU (Emulator) and SPDK (Storage Performance Development Kit).
   3. Action:
       * Clone SPDK. It is an open-source set of drivers that bypass the kernel to talk to storage directly.
       * SPDK has a Virtual NVMe Controller target. You will configure SPDK to act as an NVMe device.
       * Look for the nvmf_tgt (NVMe-over-Fabrics target) application in SPDK. This lets your computer pretend to be a storage array.

  Phase 3: The "Thesis" Project (Implementing TP4091)
  This is where you actually do the work the author mentioned.
   1. Goal: "Push down" a filter to your emulated drive.
   2. The Project:
       * Write a standard app that reads a 10GB text file and counts the word "Alpha". Measure how much data moves across the bus (10GB).
       * Now, write an eBPF program that does the counting.
       * Modify your SPDK virtual controller to accept a "Load Program" command (mimicking TP4091).
       * Execute the eBPF program inside the SPDK target (the "fake drive").
       * Return only the count (4 bytes).
   3. The Result: You just demonstrated reducing bus traffic from 10GB to 4 bytes. That is the "Career Alpha."


The above is not the final plan. It still needs a ton of refinement and research and validation

## Target Audience
- **Storage Systems Researchers:** Providing a platform for investigating next-generation storage offloading protocols.
- **Embedded Systems Engineers:** Offering a path to master eBPF in the context of hardware-constrained environments.
- **Kernel Developers:** Enabling experimentation with new NVMe standards like TP4091 before hardware availability.

## Project Goals
- **TP4091 Simulation:** Build a functional simulation environment for Computational Storage using QEMU and SPDK.
- **Learning Path:** Create a hands-on curriculum for eBPF development specifically for storage applications.
- **Performance Demonstration:** Prove the efficiency of on-drive computation by measuring bus traffic reduction.

## Key Features & Milestones
- **eBPF Environment:** Establish a robust C-based development environment using libbpf-bootstrap.
- **Virtual NVMe Controller:** Integrate QEMU and SPDK to simulate a compliant NVMe device.
- **Baseline Benchmark:** Performance baseline established using standard C application and NVMe-oF connection scripts.
- **Offloading Protocol:** Implement the "Load Program" command within SPDK to mimic the TP4091 offloading mechanism.

## Success Criteria
- **Kernel Execution:** Verify the ability to compile and run restricted C eBPF programs in the Linux kernel.
- **Custom Commands:** Confirm the simulated NVMe device correctly interprets and responds to custom vendor-specific commands.
- **Traffic Reduction:** Demonstrate a quantifiable decrease in data movement when filtering logic is pushed to the simulated drive.