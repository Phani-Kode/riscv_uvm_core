module riscv_regfile (
    input  logic        clk,
    input  logic        reset_n,
    input  logic        we,        // Write Enable
    input  logic [4:0]  rs1,       // Source Register 1 address
    input  logic [4:0]  rs2,       // Source Register 2 address
    input  logic [4:0]  rd,        // Destination Register address
    input  logic [31:0] write_data,
    output logic [31:0] read_data1,
    output logic [31:0] read_data2
);

    // 32 registers, each 32 bits wide
    logic [31:0] registers [31:0];

    // Asynchronous read
    assign read_data1 = (rs1 == 5'b0) ? 32'b0 : registers[rs1];
    assign read_data2 = (rs2 == 5'b0) ? 32'b0 : registers[rs2];

    // Synchronous write
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            for (int i = 0; i < 32; i++) begin
                registers[i] <= 32'b0;
            end
        end else if (we && (rd != 5'b0)) begin // Prevent writing to x0
            registers[rd] <= write_data;
        end
    end

endmodule
