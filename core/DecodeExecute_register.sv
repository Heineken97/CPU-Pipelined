module DecodeExecute_register (
    input logic clk,
    input logic wbs_in,
    input logic mm_in,
    input logic [2:0] ALUop_in,
	 input logic wm_in,
	 input logic am_in,
	 input logic ni_in,
	 input logic wme_in,
	 input logic alu_mux_in,
	 input logic alu_mux1_in,
	 input logic [3:0] reg_dest_in,
	 input logic [15:0] srcA_in,
	 input logic [15:0] srcB_in,
    output logic wbs_out,
    output logic wme_out,
    output logic mm_out,
    output logic [2:0] ALUop_out,
	 output logic wm_out,
	 output logic am_out,
	 output logic ni_out,
	 output logic alu_mux_out,
	 output logic alu_mux1_out,
	 output logic [3:0] reg_dest_out,
	 output logic [15:0] srcA_out,
	 output logic [15:0] srcB_out
);
    logic wbs;
    logic mm;
    logic [2:0] ALUop;
	 logic wm;
	 logic am;
	 logic ni;
	 logic wce;
    logic wme;
	 logic alu_mux;
	 logic alu_mux1;
	 logic reg_dest;
	 logic [15:0] srcA;
	 logic [15:0] srcB;
    // Proceso de escritura en el registro
    always_ff @(posedge clk) begin
        wbs 							<= wbs_in;
        mm 								<= mm_in;
        ALUop 							<= ALUop_in;
		  wm 								<= wm_in;
		  am 								<= am_in;
		  ni 								<= ni_in;
		  wme 							<= wme_in;
		  alu_mux 						<= alu_mux_in;
		  alu_mux1 						<= alu_mux1_in;
		  reg_dest 						<= reg_dest_in;
		  srcA 							<= srcA_in;
		  srcB 							<= srcB_in;
    end
    // Salidas del registro
    assign wbs_out = wbs;
    assign mm_out = mm;
    assign ALUop_out = ALUop;
	 assign wm_out = wm;
	 assign am_out = am;
	 assign ni_out = ni;
    assign wme_out = wme;
	 assign alu_mux_out = alu_mux;
	 assign alu_mux1_out = alu_mux1;
	 assign reg_dest_out = reg_dest;
	 assign srcA_out = srcA;
	 assign srcB_out = srcB;
endmodule
