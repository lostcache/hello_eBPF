# Product Guidelines

## Documentation Style & Tone
- **Technical & Rigorous:** Documentation will prioritize low-level precision. We will focus on memory layouts, register-level interactions, and exact NVMe specification details. This approach ensures that researchers and kernel developers have the necessary depth to understand the "bleeding edge" implementation of TP4091.

## Content Focus & Visuals
- **Data Flow Visualization:** We will use clear diagrams to illustrate the transition from host-side processing (high bus traffic) to drive-side offloading (minimal bus traffic). This is the core "Career Alpha" value proposition.
- **Annotated C Code:** Every code example, especially restricted C for eBPF and the SPDK target modifications, will be extensively annotated to explain the "why" behind specific low-level choices.
- **Realistic CLI Debugging:** Tutorials will include verbatim output from system tools (`bpftool`, `dmesg`, SPDK logs). This helps users navigate the complex debugging environment of simulated hardware.

## Development Philosophy
- **Verification First:** Given the complexity of eBPF and kernel-level storage, we emphasize incremental verification. No component should be integrated without a clear path to testing its specific failure modes.
