module MemoryWriteback_register (
    input logic clk,
    input logic reset,
    input logic wre_memory,
    input logic select_writeback_data_mux_memory,
	 input logic [3:0] rs1_memory,
    input logic [3:0] rs2_memory,
    input logic [3:0] rd_memory, 
    input logic [15:0] data_from_memory_in,
    input logic [15:0] calc_data_in,
    
    output logic [15:0] data_from_memory_out,
    output logic [15:0] calc_data_out,
    output logic wre_writeback,
    output logic select_writeback_data_mux_writeback,
	 output logic [3:0] rs1_writeback,
    output logic [3:0] rs2_writeback,
    output logic [3:0] rd_writeback
);

    logic [15:0] data_calculated;
    logic [15:0] data_memory;
	 logic [3:0] rs1;
	 logic [3:0] rs2;

    // Proceso de escritura en el registro
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            data_calculated <= 16'b0; 
            data_memory <= 16'b0;
            wre_writeback <= 1'b0;
            select_writeback_data_mux_writeback <= 1'b0;
            rd_writeback <= 4'b0;
				rs1 <= 4'b0;
				rs2 <= 4'b0;
        end else begin
            data_calculated <= calc_data_in;
            data_memory <= data_from_memory_in;
            wre_writeback <= wre_memory;
            select_writeback_data_mux_writeback <= select_writeback_data_mux_memory;
            rd_writeback <= rd_memory;
				rs1 <= rs1_memory;
				rs2 <= rs2_memory;
        end
    end

    // Salidas del registro
    assign calc_data_out = data_calculated;
    assign data_from_memory_out = data_memory;
	 assign rs1_writeback = rs1;
	 assign rs2_writeback = rs2;
    
endmodule
