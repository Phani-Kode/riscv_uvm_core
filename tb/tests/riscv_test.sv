`include "uvm_macros.svh"
import uvm_pkg::*;

class riscv_base_test extends uvm_test;
    `uvm_component_utils(riscv_base_test)

    riscv_env           env;
    riscv_base_sequence seq;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build Phase: Instantiate the environment
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = riscv_env::type_id::create("env", this);
    endfunction

    // Run Phase: Start the sequence and manage the simulation objection
    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        // Create and start the sequence
        seq = riscv_base_sequence::type_id::create("seq");
        seq.start(env.agent.sqr);

        // Wait a few cycles to let the final instructions drain out of the pipeline
        #100;

        phase.drop_objection(this);
    endtask
endclass
