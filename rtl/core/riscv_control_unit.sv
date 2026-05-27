import riscv_pkg::*;

module riscv_control_unit (
    input  opcode_t opcode,
    output logic    branch,
    output logic    mem_read,
    output logic    mem_to_reg,
    output logic [2:0] alu_op,
    output logic    mem_write,
    output logic    alu_src,
    output logic    reg_write
);

    always_comb begin
        // Default assignments to prevent latches
        branch     = 1'b0;
        mem_read   = 1'b0;
        mem_to_reg = 1'b0;
        alu_op     = 3'b000;
        mem_write  = 1'b0;
        alu_src    = 1'b0;
        reg_write  = 1'b0;

        case (opcode)
            OP_REG: begin       // R-type instructions (e.g., ADD, SUB)
                reg_write = 1'b1;
                alu_op    = 3'b010;
            end
            OP_IMM: begin       // I-type instructions (e.g., ADDI)
                alu_src   = 1'b1;
                reg_write = 1'b1;
                alu_op    = 3'b011;
            end
            OP_LOAD: begin      // Load instructions
                alu_src   = 1'b1;
                mem_to_reg= 1'b1;
                reg_write = 1'b1;
                mem_read  = 1'b1;
            end
            OP_STORE: begin     // Store instructions
                alu_src   = 1'b1;
                mem_write = 1'b1;
            end
            OP_BRANCH: begin    // Branch instructions
                branch    = 1'b1;
                alu_op    = 3'b001;
            end
            default: ; // Do nothing
        endcase
    end
endmodule
