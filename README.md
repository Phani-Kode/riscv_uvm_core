# 5-Stage Pipelined RISC-V RV32I Core with UVM Verification

## Overview
This repository contains the RTL design and comprehensive pre-silicon verification environment for a 32-bit RISC-V processor core (RV32I instruction set). Designed from scratch using SystemVerilog, the core features a classic 5-stage pipeline with full data hazard detection and forwarding logic.

The project heavily emphasizes verification, featuring a complete Universal Verification Methodology (UVM) testbench designed to stress-test pipeline stalls, branch predictions, and memory alignments, achieving **95%+ functional and code coverage**.

## Key Features
* **Architecture:** In-order 5-stage pipeline (Fetch, Decode, Execute, Memory, Writeback).
* **Instruction Set:** Full support for the RISC-V RV32I base integer instruction set.
* **Hazard Handling:** Integrated forwarding unit to minimize pipeline stalls and a hazard detection unit for load-use delays.
* **Verification (UVM):** Constrained-random testbenches, SVA assertions, self-checking scoreboards, and functional coverage models.
* **Tools Used:** SystemVerilog, UVM, QuestaSim / Synopsys VCS, Makefiles, Linux.

## Directory Structure
```
riscv_uvm_core/
├── docs/               # Architecture specs and block diagrams
├── rtl/                # SystemVerilog Design Files
│   ├── core/           # Pipeline stages, ALU, Control Unit, RegFile
│   └── include/        # Global definitions and packages
├── tb/                 # UVM Testbench Environment
│   ├── agent/          # Sequencer, Driver, Monitor, Transaction items
│   ├── env/            # Environment, Scoreboard, Coverage model
│   ├── sequences/      # Constrained-random and directed sequences
│   └── tests/          # Top-level UVM tests
├── scripts/            # Makefiles for EDA tools (QuestaSim/VCS)
└── README.md
```

* `/rtl`: SystemVerilog design files (ALU, Register File, Pipeline Registers).
* `/tb`: UVM components (Agent, Environment, Scoreboard, Sequences).
* `/scripts`: Makefiles and Tcl scripts for automated regression execution.
