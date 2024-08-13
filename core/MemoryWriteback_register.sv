module MemoryWriteback_register (
    input logic clk,
    input logic wbs_in,
    input logic [15:0] memData_in,
	 input logic [15:0] calcData_in,
	 input logic ni_in,
	 input logic reg_dest_in,
	 
    output logic wbs_out,
	 output logic [15:0] memData_out,
	 output logic [15:0] calcData_out,
	 output logic ni_out,
	 output logic reg_dest_out
);
    logic wbs;
	 logic [15:0] memData;
	 logic [15:0] calcData;
	 logic ni;
	 logic reg_dest;
    // Proceso de escritura en el registro
    always_ff @(posedge clk) begin
        wbs <= wbs_in;
		  memData <= memData_in;
		  calcData <= calcData_in;
		  ni <= ni_in;
		  reg_dest <= reg_dest_in;
    end
    // Salidas del registro
    assign wbs_out = wbs;
	 assign memData_out = memData;
    assign calcData_out = calcData;
    assign ni_out = ni;
	 assign reg_dest_out = reg_dest;
endmodule
