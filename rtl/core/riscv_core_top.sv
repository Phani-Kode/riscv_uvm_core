import riscv_pkg::*;

module riscv_core_top (
    input  logic        clk,
    input  logic        reset_n,
    // Memory Interfaces (Simplified for core-level testing)
    output logic [31:0] inst_addr,
    input  logic [31:0] inst_data,
    output logic [31:0] data_addr,
    output logic [31:0] data_wdata,
    input  logic [31:0] data_rdata,
    output logic        data_we,
    output logic        data_re
);

    // Internal signals for wiring stages
    logic stall, flush;
    logic [31:0] pc, instruction;
    logic [31:0] alu_result;
    logic branch_taken;

    // --- Instruction Fetch Stage ---
    riscv_if u_if (
        .clk(clk), .reset_n(reset_n), .stall(stall), .flush(flush),
        .branch_pc(alu_result), .pc(pc), .instruction(instruction)
    );
    assign inst_addr = pc;

    // --- Decode Stage & Control ---
    logic [4:0] rs1 = instruction[19:15];
    logic [4:0] rs2 = instruction[24:20];
    logic [4:0] rd  = instruction[11:7];
    opcode_t opcode = opcode_t'(instruction[6:0]);

    riscv_control_unit u_control (
        .opcode(opcode), .branch(branch_taken), /* ... wire other signals ... */
    );

    riscv_regfile u_regfile (
        .clk(clk), .reset_n(reset_n), .we(), .rs1(rs1), .rs2(rs2), .rd(rd),
        .write_data(), .read_data1(), .read_data2()
    );

    // --- Hazard & Forwarding ---
    riscv_hazard_detection u_hazard (
        .mem_read_ex(), .rd_ex(), .rs1_id(rs1), .rs2_id(rs2), .stall(stall)
    );

    // (Note: To complete the RTL, you will instantiate the ALU, Forwarding Unit,
    // and add the D-Flip Flops for the IF/ID, ID/EX, EX/MEM, and MEM/WB pipeline registers here).

endmodule
