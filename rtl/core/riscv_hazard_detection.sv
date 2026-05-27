module riscv_hazard_detection (
    input  logic       mem_read_ex, // 1 if instruction in EX stage is a LOAD
    input  logic [4:0] rd_ex,       // Destination register of instruction in EX stage
    input  logic [4:0] rs1_id,      // Source register 1 in ID stage
    input  logic [4:0] rs2_id,      // Source register 2 in ID stage
    output logic       stall        // Signal to stall PC and IF/ID, and flush ID/EX
);

    always_comb begin
        // Load-use data hazard condition:
        // If the EX stage instruction is a Load, and its destination matches
        // either of the source registers in the current ID stage instruction.
        if (mem_read_ex && (rd_ex != 5'b0) && ((rd_ex == rs1_id) || (rd_ex == rs2_id))) begin
            stall = 1'b1; // Trigger pipeline stall
        end else begin
            stall = 1'b0; // Normal execution
        end
    end

endmodule
