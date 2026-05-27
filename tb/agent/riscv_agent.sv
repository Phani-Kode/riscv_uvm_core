`include "uvm_macros.svh"
import uvm_pkg::*;

class riscv_agent extends uvm_agent;
    `uvm_component_utils(riscv_agent)

    // Declare the components
    uvm_sequencer #(riscv_seq_item) sqr;
    riscv_driver                    drv;
    riscv_monitor                   mon;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build Phase: Instantiate the components
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // The monitor is always built
        mon = riscv_monitor::type_id::create("mon", this);

        // Sequencer and Driver are only built if the agent is ACTIVE
        // (meaning it's driving the bus, not just passively observing)
        if (get_is_active() == UVM_ACTIVE) begin
            sqr = uvm_sequencer#(riscv_seq_item)::type_id::create("sqr", this);
            drv = riscv_driver::type_id::create("drv", this);
        end
    endfunction

    // Connect Phase: Wire the Sequencer to the Driver
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (get_is_active() == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        end
    endfunction
endclass
