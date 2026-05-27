`include "riscv_pkg.sv"

module alu
  import riscv_pkg::*;
(
  input  logic [31:0] operand_a,
  input  logic [31:0] operand_b,
  input  alu_op_t     alu_op,
  output logic [31:0] result,
  output logic        zero
);

  always_comb begin
    unique case (alu_op)
      ALU_ADD  : result = operand_a + operand_b;
      ALU_SUB  : result = operand_a - operand_b;
      ALU_SLL  : result = operand_a << operand_b[4:0];
      ALU_SLT  : result = {31'b0, $signed(operand_a) < $signed(operand_b)};
      ALU_SLTU : result = {31'b0, operand_a < operand_b};
      ALU_XOR  : result = operand_a ^ operand_b;
      ALU_SRL  : result = operand_a >> operand_b[4:0];
      ALU_SRA  : result = $signed(operand_a) >>> operand_b[4:0];
      ALU_OR   : result = operand_a | operand_b;
      ALU_AND  : result = operand_a & operand_b;
      default  : result = 32'b0;
    endcase
  end

  assign zero = (result == 32'b0);

endmodule : alu
