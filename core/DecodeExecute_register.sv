module DecodeExecute_register (
    input logic clk,
    input logic reset,
    input logic [15:0] nop_mux_output_in,	 
    input logic [15:0] srcA_in,
    input logic [15:0] srcB_in,
	 
	 input logic [3:0] rs1_decode,
	 input logic [3:0] rs2_decode,
	 input logic [3:0] rd_decode,
	 
    output logic wre_execute,
    output logic write_memory_enable_execute,
    output logic [1:0] select_writeback_data_mux_execute,
    output logic [3:0] aluOp_execute,
    output logic [15:0] srcA_out,
    output logic [15:0] srcB_out,
	 
	 output logic [3:0] rs1_execute,
	 output logic [3:0] rs2_execute,
	 output logic [3:0] rd_execute
);

    logic [15:0] srcA;
    logic [15:0] srcB;
	 logic [3:0] rs1;
	 logic [3:0] rs2;
	 logic [3:0] rd;

    always_ff @(posedge clk) begin
        if (reset) begin
            wre_execute <= 1'b0;
            write_memory_enable_execute <= 1'b0;
            select_writeback_data_mux_execute <= 2'b00;
            aluOp_execute <= 4'b0;
            srcA <= 16'b0;
            srcB <= 16'b0;
				rs1 <= 4'b0;
				rs2 <= 4'b0;
				rd <= 4'b0;
        end else begin
            wre_execute <= nop_mux_output_in[7];
				write_memory_enable_execute <= nop_mux_output_in[6];
				select_writeback_data_mux_execute <= nop_mux_output_in[5:4];
				aluOp_execute <= nop_mux_output_in[3:0];
            srcA <= srcA_in;
            srcB <= srcB_in;
				rs1 <= rs1_decode;
				rs2 <= rs2_decode;
				rd <= rd_decode;
        end
    end

    assign srcA_out = srcA;
    assign srcB_out = srcB;
	 assign rs1_execute = rs1;
	 assign rs2_execute = rs2;
	 assign rd_execute = rd;

endmodule
