import uvm_pkg::*;
`include "uvm_macros.svh"

// Include your UVM files here (or manage this via your Makefile)
// `include "riscv_test.sv"

module tb_top;
    logic clk;
    logic reset_n;

    // 1. Clock Generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // 2. Reset Generation
    initial begin
        reset_n = 0;
        #20 reset_n = 1;
    end

    // 3. Instantiate the SystemVerilog Interface
    riscv_core_if vif(
        .clk(clk),
        .reset_n(reset_n)
    );

    // 4. Instantiate the Design Under Test (DUT)
    riscv_core_top dut (
        .clk(vif.clk),
        .reset_n(vif.reset_n),
        .inst_addr(vif.inst_addr),
        .inst_data(vif.inst_data),
        .data_addr(vif.data_addr),
        .data_wdata(vif.data_wdata),
        .data_rdata(vif.data_rdata),
        .data_we(vif.data_we),
        .data_re(vif.data_re)
    );

    // 5. Pass Virtual Interface to UVM and Run Test
    initial begin
        // Place the virtual interface into the UVM configuration database
        uvm_config_db#(virtual riscv_core_if)::set(null, "*", "vif", vif);

        // Start the UVM phases
        run_test("riscv_base_test");
    end

    // Optional: Dump waveforms for QuestaSim or VCS debugging
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_top);
    end
endmodule
