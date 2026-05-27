`include "uvm_macros.svh"
import uvm_pkg::*;

class riscv_env extends uvm_env;
    `uvm_component_utils(riscv_env)

    // Declare the Agent and Scoreboard
    riscv_agent      agent;
    riscv_scoreboard scb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build Phase: Instantiate the agent and scoreboard
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = riscv_agent::type_id::create("agent", this);
        scb   = riscv_scoreboard::type_id::create("scb", this);
    endfunction

    // Connect Phase: Wire the Monitor's Analysis Port to the Scoreboard
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // This connection ensures every item the monitor sees is sent to the scoreboard
        agent.mon.ap.connect(scb.ap_export);
    endfunction
endclass
