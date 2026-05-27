import riscv_pkg::*; // Import ALU operations from your package

module riscv_alu (
    input  logic [31:0] operand_a,
    input  logic [31:0] operand_b,
    input  alu_op_t     alu_op,
    output logic [31:0] alu_result,
    output logic        zero
);

    always_comb begin
        case (alu_op)
            ALU_ADD:  alu_result = operand_a + operand_b;
            ALU_SUB:  alu_result = operand_a - operand_b;
            ALU_SLL:  alu_result = operand_a << operand_b[4:0];
            ALU_SLT:  alu_result = ($signed(operand_a) < $signed(operand_b)) ? 32'b1 : 32'b0;
            ALU_SLTU: alu_result = (operand_a < operand_b) ? 32'b1 : 32'b0;
            ALU_XOR:  alu_result = operand_a ^ operand_b;
            ALU_SRL:  alu_result = operand_a >> operand_b[4:0];
            ALU_SRA:  alu_result = $signed(operand_a) >>> operand_b[4:0];
            ALU_OR:   alu_result = operand_a | operand_b;
            ALU_AND:  alu_result = operand_a & operand_b;
            default:  alu_result = 32'b0;
        endcase
    end

    // Zero flag (useful for branch instructions)
    assign zero = (alu_result == 32'b0);

endmodule
