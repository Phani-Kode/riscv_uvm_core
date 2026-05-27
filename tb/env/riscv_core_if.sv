interface riscv_core_if (
    input logic clk,
    input logic reset_n
);
    // Instruction Memory Interface
    logic [31:0] inst_addr;
    logic [31:0] inst_data;

    // Data Memory Interface
    logic [31:0] data_addr;
    logic [31:0] data_wdata;
    logic [31:0] data_rdata;
    logic        data_we;
    logic        data_re;

    // Optional: SVA (SystemVerilog Assertions) can be added here
    // Example: Ensure data write and read aren't high simultaneously
    property p_no_simultaneous_rw;
        @(posedge clk) disable iff (!reset_n)
        not (data_we && data_re);
    endproperty
    assert property (p_no_simultaneous_rw) else $error("Simultaneous memory read and write detected!");

endinterface
