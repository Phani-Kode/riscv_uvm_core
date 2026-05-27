`include "uvm_macros.svh"
import uvm_pkg::*;

class riscv_seq_item extends uvm_sequence_item;

    // Randomize instruction fields to stress-test the pipeline
    rand logic [31:0] instruction;
    rand logic [31:0] data_rdata; // Mock data read from memory

    // Extracted fields for easy monitoring and coverage tracking
    logic [6:0] opcode;
    logic [4:0] rs1, rs2, rd;

    `uvm_object_utils_begin(riscv_seq_item)
        `uvm_field_int(instruction, UVM_ALL_ON)
        `uvm_field_int(data_rdata, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "riscv_seq_item");
        super.new(name);
    endfunction

    // Post-randomize function to extract fields for UVM scoreboards
    function void post_randomize();
        opcode = instruction[6:0];
        rd     = instruction[11:7];
        rs1    = instruction[19:15];
        rs2    = instruction[24:20];
    endfunction

    // Add constraints to ensure valid RISC-V opcodes are generated
    constraint valid_opcodes {
        instruction[6:0] inside {
            7'b0110111, // LUI
            7'b1100011, // BRANCH
            7'b0000011, // LOAD
            7'b0100011, // STORE
            7'b0010011, // IMM
            7'b0110011  // REG
        };
    }
endclass
