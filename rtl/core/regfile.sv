module regfile (
  input  logic        clk,
  input  logic        rst_n,

  // Read ports (Decode stage)
  input  logic [4:0]  rs1_addr,
  input  logic [4:0]  rs2_addr,
  output logic [31:0] rs1_data,
  output logic [31:0] rs2_data,

  // Write port (Writeback stage)
  input  logic        we,
  input  logic [4:0]  rd_addr,
  input  logic [31:0] rd_data
);

  logic [31:0] regs [31:0];

  // x0 is hardwired to zero per RV32I spec
  assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : regs[rs1_addr];
  assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : regs[rs2_addr];

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      foreach (regs[i]) regs[i] <= 32'b0;
    end else if (we && rd_addr != 5'b0) begin
      regs[rd_addr] <= rd_data;
    end
  end

endmodule : regfile
