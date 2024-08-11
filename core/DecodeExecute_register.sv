module DecodeExecute_register (
    input logic clk,
	 input logic [3:0] aluOp_in,	 
	 input logic [15:0] srcA_in,
	 input logic [15:0] srcB_in,
	 
	 output logic [3:0] aluOp_out,
	 output logic [15:0] srcA_out,
	 output logic [15:0] srcB_out
);

    
    logic [3:0] aluOp;	 
	 logic [15:0] srcA;
	 logic [15:0] srcB;
    
    // Proceso de escritura en el registro
    always_ff @(posedge clk) begin
        aluOp <= aluOp_in;		  
		  srcA <= srcA_in;
		  srcB <= srcB_in;
    end

    // Salidas del registro
    assign aluOp_out = aluOp;	 
	 assign srcA_out = srcA;
	 assign srcB_out = srcB;

endmodule
