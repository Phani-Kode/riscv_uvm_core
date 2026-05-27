`include "uvm_macros.svh"
import uvm_pkg::*;

class riscv_monitor extends uvm_monitor;
    `uvm_component_utils(riscv_monitor)

    // Virtual interface to observe DUT signals
    virtual riscv_core_if vif;

    // Analysis port to send captured transactions to the scoreboard/coverage
    uvm_analysis_port #(riscv_seq_item) ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual riscv_core_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"});
        end
    endfunction

    task run_phase(uvm_phase phase);
        riscv_seq_item item;

        // Wait for reset to clear
        @(posedge vif.clk iff vif.reset_n == 1'b1);

        forever begin
            @(posedge vif.clk);

            // Only capture valid instructions (basic check)
            if (vif.inst_data != 32'h00000000) begin
                item = riscv_seq_item::type_id::create("item");

                // Capture signals
                item.instruction = vif.inst_data;

                // If it's a memory read or write, capture that data as well
                if (vif.data_we) begin
                    // Store operation capture
                    // (You would add logic to capture data_addr and data_wdata here)
                end else if (vif.data_re) begin
                    // Load operation capture
                    item.data_rdata = vif.data_rdata;
                end

                // Send the captured transaction to the scoreboard
                ap.write(item);
            end
        end
    endtask
endclass
