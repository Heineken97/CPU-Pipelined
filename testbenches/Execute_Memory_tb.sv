`timescale 1ps/1ps
module Execute_Memory_tb;
	logic clk = 0;
	logic [3:0] mux_output_2 = 4'b001;
	logic [15:0] read_addres_or_data;
	logic [15:0] alu_result;
	// Senales de Control 
	logic wbs_decode; 
	logic mm_decode;
   logic [2:0] ALUop_decode;
   logic wm_decode;
   logic am_decode;
   logic ni_decode;
	logic wme_decode;
	logic alu_mux_decode,alu_mux1_decode;
	logic [3:0] reg_dest_decode = 4'b001;
	logic [15:0] srcA_decode;
	logic [15:0] srcB_decode;
	// Registro Execute
	logic wbs_execute; 
	logic mm_execute;
   logic [2:0] ALUop_execute;
   logic wm_execute;
   logic am_execute;
   logic ni_execute;
	logic wme_execute;
	logic alu_mux_execute,alu_mux1_execute;
	logic [3:0] reg_dest_execute;
	logic [15:0] srcA_execute;
	logic [15:0] srcB_execute;
	//Registro Memory
	logic wbs_memory;   
	logic mm_memory;
	logic alu_result_memory;
	logic write_Data_memory;
	logic wm_memory;
	logic ni_memory;	
	logic wme_memory;
	logic [3:0] reg_dest_memory;

	DecodeExecute_register DecodeExecute_register_instance (
		.clk(clk),
      .wbs_in(wbs_decode),
      .mm_in(mm_decode),
      .ALUop_in(ALUop_decode),
      .wm_in(wm_decode),
      .am_in(am_decode),
      .ni_in(ni_decode),
		.wme_in(wme_decode),
		.alu_mux_in(alu_mux_decode),
		.alu_mux1_in(alu_mux1_decode),
		.reg_dest_in(mux_output_2),
		.srcA_in(srcA_decode),
		.srcB_in(srcB_decode),
		
      .wbs_out(wbs_execute),
      .mm_out(mm_execute),
      .ALUop_out(ALUop_execute),
      .wm_out(wm_execute),
      .am_out(am_execute),
      .ni_out(ni_execute),
		.wme_out(wme_execute),
		.alu_mux_out(alu_mux_execute),
		.alu_mux1_out(alu_mux1_execute),
		.reg_dest_out(reg_dest_execute),
		.srcA_out(srcA_execute),
		.srcB_out(srcB_execute)
   ); 
	//Decodificador debajo de Alu
	decoderMemory decoder_instance (
		.data_in(srcB_execute),
		.select(am_execute),
		.data_out_0(read_addres_or_data),
		.data_out_1(write_Data_execute)
   );
	//Mux antes del registro de etapa
	mux_2 mux_2_source_or_address (
      .data0(srcA_execute),
      .data1(output_alu_mux), 
      .select(alu_mux1_execute),
      .out(output_execute)
   );
	//Alu
	ALU ALU_instance (
      .ALUop(ALUop_execute),       
      .srcA(srcA_execute),
      .srcB(srcB_execute),
      .ALUresult(alu_result),
      .flagN(flagN),
      .flagZ(flagZ)
   );
	//Mux despues de la Alu
	mux_2 u_mux_2 (
		.data0(alu_result),
		.data1(read_addres_or_data),
		.select(alu_mux_execute),		
		.out(output_alu_mux)
   );
///////////// REGISTRO PIPELINE EXECUTE- MEMORY ///////////////////////////////////////////////////////////
	ExecuteMemory_register ExecuteMemory_register_instance (
		.clk(clk),
      .wbs_in(wbs_execute),
      .mm_in(mm_execute),
      .ALUresult_in(output_alu_mux), 
      .memData_in(write_Data_execute),
      .wm_in(wm_execute),
      .ni_in(ni_execute),
		.wme_in(wme_execute),
		.reg_dest_in(reg_dest_execute),
		
      .wbs_out(wbs_memory),
      .mm_out(mm_memory),
      .ALUresult_out(alu_result_memory),
      .memData_out(write_Data_memory),
      .wm_out(wm_memory),
      .ni_out(ni_memory),
		.wme_out(wme_memory),
		.reg_dest_out(reg_dest_memory)
   );

	
	always #10 clk = ~clk;
	initial begin
		// Ciclo 1:
      $display("1 Primer ciclo ----------------------------------------------------------");
      // Asigna valores simulados para las entradas del DecodeExecute_register
      ALUop_decode = 3'b000;
		wbs_decode = 1; 
		mm_decode = 2'b00;
      wm_decode = 0;
      am_decode = 1'bx;
      ni_decode = 0;
		wme_decode = 1'bx;
		alu_mux_decode = 1'b0 ;
		alu_mux1_decode = 1'b1 ;
		mux_output_2 = 4'b1;
      srcA_decode = 16'b0000000000000001;
      srcB_decode = 16'b0000000000000001;

		$display("\n \n \n");
		
		#20
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// Ciclo 2:
      $display("2 Segungo ciclo ----------------------------------------------------------");
      // Asigna valores simulados para las entradas del DecodeExecute_register
      ALUop_decode = 3'b001;
		wbs_decode = 1; 
		mm_decode = 2'b00;
      wm_decode = 0;
      am_decode = 1'bx;
      ni_decode = 0;
		wme_decode = 1'bx;
		alu_mux_decode = 1'b0 ;
		alu_mux1_decode = 1'b1 ;
		mux_output_2 = 4'b1;
      srcA_decode = 16'b0000000000000010;
      srcB_decode = 16'b0000000000000001;
		
		$display("\n \n \n");
		
		#20
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		// Ciclo 3:
      $display("3 tercer ciclo ----------------------------------------------------------");
      // Asigna valores simulados para las entradas del DecodeExecute_register
      ALUop_decode = 3'b010;
		wbs_decode = 0; 
		mm_decode = 2'b01;
      wm_decode = 1;
      am_decode = 1'bx;
      ni_decode = 1;
		wme_decode = 1'bx;
		alu_mux_decode = 1'b1 ;
		alu_mux1_decode = 1'b0 ;
		mux_output_2 = 4'b1;
      srcA_decode = 16'b0000000000000011;
      srcB_decode = 16'b0000000000000001;
		

		$display("\n \n \n");
		#20
		////////////////////////////////////////////////////////////////////////////////////////////////////
      $finish;
    end
endmodule
