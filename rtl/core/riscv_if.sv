module riscv_if (
    input  logic        clk,
    input  logic        reset_n,
    input  logic        stall,      // Halts the PC update (from Hazard Detection)
    input  logic        flush,      // Overwrites PC (from Branch resolution in EX stage)
    input  logic [31:0] branch_pc,  // Target PC if a branch is taken
    output logic [31:0] pc,
    output logic [31:0] instruction
);

    logic [31:0] pc_next;

    // Determine the next PC value
    assign pc_next = flush ? branch_pc : (stall ? pc : pc + 4);

    // PC Register
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            pc <= 32'h0000_0000;
        end else begin
            pc <= pc_next;
        end
    end

    // Instruction Memory (Simplified for RTL core testing)
    // In a full SoC, this would interface with an AXI memory controller
    logic [31:0] imem [0:255];

    // Fetch instruction based on word-aligned PC
    assign instruction = imem[pc[9:2]];

endmodule
