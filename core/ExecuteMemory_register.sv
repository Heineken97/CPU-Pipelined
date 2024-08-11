module ExecuteMemory_register (
    input logic clk,
	 input logic reset,
    input logic [15:0] ALUresult_in,
	 output logic [15:0] ALUresult_out
);

    logic [15:0] ALUresult;   

    // Proceso de escritura en el registro
    always_ff @(posedge clk) begin
		 if (reset) begin
            ALUresult <= 16'b0; // Inicializar el registro a 0 cuando se activa el reset
		  end else begin
				ALUresult <= ALUresult_in;
		  end
    end

    // Salidas del registro
    assign ALUresult_out = ALUresult;
	 
endmodule