# Makefile for RISC-V RV32I Core UVM Verification
# Target EDA Tool: QuestaSim / ModelSim

# Directory Paths
RTL_DIR = ../rtl
TB_DIR  = ../tb
WORK_DIR = work

# SystemVerilog RTL Files
RTL_FILES = $(RTL_DIR)/include/riscv_pkg.sv \
            $(RTL_DIR)/core/riscv_regfile.sv \
            $(RTL_DIR)/core/riscv_alu.sv \
            $(RTL_DIR)/core/riscv_if.sv \
            $(RTL_DIR)/core/riscv_forwarding.sv \
            $(RTL_DIR)/core/riscv_control_unit.sv \
            $(RTL_DIR)/core/riscv_hazard_detection.sv \
            $(RTL_DIR)/core/riscv_core_top.sv

# UVM Testbench Files
TB_FILES = $(TB_DIR)/env/riscv_core_if.sv \
           $(TB_DIR)/agent/riscv_seq_item.sv \
           $(TB_DIR)/agent/riscv_monitor.sv \
           $(TB_DIR)/agent/riscv_driver.sv \
           $(TB_DIR)/agent/riscv_agent.sv \
           $(TB_DIR)/env/riscv_scoreboard.sv \
           $(TB_DIR)/env/riscv_env.sv \
           $(TB_DIR)/sequences/riscv_sequence.sv \
           $(TB_DIR)/tests/riscv_test.sv \
           $(TB_DIR)/tb_top.sv

# UVM Flags (QuestaSim includes pre-compiled UVM libraries)
# Use +incdir to allow the compiler to find standard UVM macros and user includes
UVM_FLAGS = -L mtiUvm -uvmcontrol=all

.PHONY: all clean compile simulate

# Default target
all: clean compile simulate

# Compile the design and testbench
compile:
	@echo "--- Compiling RTL and UVM Testbench ---"
	vlib $(WORK_DIR)
	vmap work $(WORK_DIR)
	vlog -work $(WORK_DIR) +acc $(UVM_FLAGS) $(RTL_FILES) $(TB_FILES)

# Run the UVM Simulation
simulate:
	@echo "--- Running UVM Simulation ---"
	vsim -c -do "run -all; exit" $(WORK_DIR).tb_top +UVM_TESTNAME=riscv_base_test

# Clean up generated files
clean:
	@echo "--- Cleaning up ---"
	rm -rf $(WORK_DIR) transcript vsim.wlf *.vcd
