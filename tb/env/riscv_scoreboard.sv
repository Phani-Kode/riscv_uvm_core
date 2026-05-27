`include "uvm_macros.svh"
import uvm_pkg::*;

class riscv_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(riscv_scoreboard)

    // Analysis export to receive items from the monitor
    uvm_analysis_imp #(riscv_seq_item, riscv_scoreboard) ap_export;

    // Simulated Register File for the Golden Reference Model
    logic [31:0] ref_regfile [31:0];

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap_export = new("ap_export", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Initialize reference register file
        foreach (ref_regfile[i]) ref_regfile[i] = 32'h0;
    endfunction

    // The write function is automatically called when the monitor calls ap.write(item)
    virtual function void write(riscv_seq_item item);
        // Extract fields
        logic [6:0] opcode = item.instruction[6:0];
        logic [4:0] rd     = item.instruction[11:7];
        logic [4:0] rs1    = item.instruction[19:15];
        logic [4:0] rs2    = item.instruction[24:20];

        `uvm_info("SCB", $sformatf("Received Instruction: %0h (Opcode: %0b)", item.instruction, opcode), UVM_LOW);

        // Simple Reference Model Check (Example for an R-Type ALU Operation)
        if (opcode == 7'b0110011) begin // OP_REG
            // Note: In a complete scoreboard, you'd decode funct3 and funct7 to know the exact ALU op.
            // Here is a pseudo-check assuming an ADD operation.
            logic [31:0] expected_result;
            expected_result = ref_regfile[rs1] + ref_regfile[rs2];

            // Update reference model
            if (rd != 0) ref_regfile[rd] = expected_result;

            `uvm_info("SCB_CHK", $sformatf("R-Type Op detected. rs1:%0d rs2:%0d rd:%0d", rs1, rs2, rd), UVM_LOW);
        end

        // You will expand this to cover IMM, LOAD, STORE, and BRANCH opcodes
        // to verify your forwarding and hazard detection logic.
    endfunction
endclass
