`include "uvm_macros.svh"
import uvm_pkg::*;

class riscv_driver extends uvm_driver #(riscv_seq_item);

    // Register the component with the UVM factory
    `uvm_component_utils(riscv_driver)

    // Virtual interface to the DUT
    virtual riscv_core_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build Phase: Get the virtual interface from the config DB
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual riscv_core_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
        end
    endfunction

    // Run Phase: Continuously grab items and drive them
    task run_phase(uvm_phase phase);
        // Wait for reset to deassert
        @(posedge vif.clk iff vif.reset_n == 1'b1);

        forever begin
            seq_item_port.get_next_item(req);
            drive_item(req);
            seq_item_port.item_done();
        end
    endtask

    // Task to drive the physical signals
    task drive_item(riscv_seq_item item);
        @(posedge vif.clk);
        // Feed the randomized instruction into the core
        vif.inst_data <= item.instruction;

        // Mock the data returned from memory for load instructions
        if (vif.data_re) begin
            vif.data_rdata <= item.data_rdata;
        end
    endtask

endclass
