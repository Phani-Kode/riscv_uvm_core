module riscv_forwarding (
    input  logic [4:0] rs1_ex,         // Source reg 1 in Execute stage
    input  logic [4:0] rs2_ex,         // Source reg 2 in Execute stage
    input  logic [4:0] rd_mem,         // Destination reg in Memory stage
    input  logic [4:0] rd_wb,          // Destination reg in Writeback stage
    input  logic       reg_write_mem,  // Write Enable from Memory stage
    input  logic       reg_write_wb,   // Write Enable from Writeback stage
    output logic [1:0] forward_a,      // MUX control for ALU Operand A
    output logic [1:0] forward_b       // MUX control for ALU Operand B
);

    // Forwarding logic for Operand A
    always_comb begin
        if (reg_write_mem && (rd_mem != 5'b0) && (rd_mem == rs1_ex)) begin
            forward_a = 2'b10; // Forward from EX/MEM pipeline register
        end else if (reg_write_wb && (rd_wb != 5'b0) && (rd_wb == rs1_ex)) begin
            forward_a = 2'b01; // Forward from MEM/WB pipeline register
        end else begin
            forward_a = 2'b00; // No forwarding; read from Decode stage
        end
    end

    // Forwarding logic for Operand B
    always_comb begin
        if (reg_write_mem && (rd_mem != 5'b0) && (rd_mem == rs2_ex)) begin
            forward_b = 2'b10; // Forward from EX/MEM pipeline register
        end else if (reg_write_wb && (rd_wb != 5'b0) && (rd_wb == rs2_ex)) begin
            forward_b = 2'b01; // Forward from MEM/WB pipeline register
        end else begin
            forward_b = 2'b00; // No forwarding; read from Decode stage
        end
    end

endmodule
