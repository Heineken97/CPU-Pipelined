module ExecuteMemory_register(input logic clk,
	input logic wbs_in,
	input logic mm_in,
   input logic [15:0] ALUresult_in, 
   input logic memData_in,
   input logic wm_in,
   input logic ni_in,
	input logic wme_in,
	input logic  [4:0] reg_dest_in,
	input logic  [4:0] reg_dest_data_writeback_in,
	output logic wbs_out,
	output logic mm_out,
   output logic [15:0] ALUresult_out,
   output logic memData_out,
   output logic wm_out,
   output logic ni_out,
	output logic wme_out,
	output logic  [4:0] reg_dest_out,
	output logic  [4:0] reg_dest_data_writeback_out
);
	logic wbs;
	logic mm;
   logic [15:0] ALUresult; 
   logic memData;
   logic wm;
   logic ni;
	logic wme;
	logic [4:0] reg_dest ;
	logic [4:0] reg_dest_data_writeback;
	// Proceso de escritura en el registro
	always_ff @(posedge clk) begin
		wbs 							<= wbs_in;
      mm 							<= mm_in;
      ALUresult 					<= ALUresult_in;
		memData						<= memData_in;
		wm 							<= wm_in;
		ni 							<= ni_in;
		wme 							<= wme_in;
		reg_dest 					<= reg_dest_in;
		reg_dest_data_writeback <= reg_dest_data_writeback_in;
	end
	// Salidas del registro
   assign wbs_out 							= wbs;
   assign mm_out 								= mm;
   assign ALUresult_out						= ALUresult;
	assign memData_out 						= memData;
	assign wm_out 								= wm;
	assign ni_out 								= ni;
   assign wme_out 							= wme;
	assign reg_dest_out 						= reg_dest;
	assign reg_dest_data_writeback_out  = reg_dest_data_writeback;
endmodule
