`include "uvm_macros.svh"
import uvm_pkg::*;

class riscv_base_sequence extends uvm_sequence #(riscv_seq_item);
    `uvm_object_utils(riscv_base_sequence)

    function new(string name = "riscv_base_sequence");
        super.new(name);
    endfunction

    task body();
        riscv_seq_item req;
        // Generate 50 randomized instructions for this base test
        repeat(50) begin
            req = riscv_seq_item::type_id::create("req");
            start_item(req);

            // Randomize the instruction and check for failure
            if(!req.randomize()) begin
                `uvm_fatal("SEQ", "Randomization failed")
            end

            finish_item(req);
        end
    endtask
endclass
