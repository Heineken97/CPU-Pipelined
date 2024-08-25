module MemoryWriteback_register (
    input logic clk,
	 input logic reset,
	 input logic [15:0] data_from_memory_in,
	 input logic [15:0] calc_data_in,
	 output logic [15:0] data_from_memory_out,
	 output logic [15:0] calc_data_out
);

    logic [15:0] data_calculated;
	 logic [15:0] data_memory;

    // Proceso de escritura en el registro
    always_ff @(posedge clk) begin
		  if (reset) begin
            data_calculated <= 16'b0; 
				data_memory <= 16'b0;
		  end else begin
				data_calculated <= calcData_in;
				data_memory <= data_from_memory;
		  end
    end

    // Salidas del registro
    assign calc_data_out = data_calculated;
	 assign data_from_memory_out = data_memory;
    
endmodule
