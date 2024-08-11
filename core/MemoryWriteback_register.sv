module MemoryWriteback_register (
    input logic clk,
	 input logic reset,
	 input logic [15:0] calcData_in,
	 output logic [15:0] calcData_out
);

    logic [15:0] calcData;

    // Proceso de escritura en el registro
    always_ff @(posedge clk) begin
		  if (reset) begin
            calcData <= 16'b0; 
		  end else begin
				calcData <= calcData_in;
		  end
    end

    // Salidas del registro
    assign calcData_out = calcData;
    
endmodule