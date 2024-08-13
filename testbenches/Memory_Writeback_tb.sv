`timescale 1ps/1ps
module Memory_Writeback_tb;
	// Registro Execute
	logic clk = 0;
	logic wbs_execute; 
	logic mm_execute;
   logic wm_execute;
   logic ni_execute;
	logic wme_execute;
	logic alu_mux_execute,alu_mux1_execute;
	logic [3:0] reg_dest_execute;
	logic [15:0] output_execute = 16'b0;
	logic [15:0] write_Data_execute = 16'b0;
	//Registro Memory
	logic wbs_memory;   
	logic mm_memory;
	logic alu_result_memory;
	logic wm_memory;
	logic ni_memory;	
	logic wme_memory;
	logic [3:0] reg_dest_memory;
	logic [15:0] address_memory;
	logic [15:0] write_Data_memory;
	logic [15:0] write_register_Data_memory;
	logic [15:0] mem_Data_memory;
	logic reg_dest_writeback;
	logic [15:0] mem_Data_writeback;
	logic [15:0] calcData_writeback;
	logic [15:0] data_writeback;	
	logic [3:0] reg_dest_data_writeback;

	ExecuteMemory_register ExecuteMemory_register_instance (
		.clk(clk),
      .wbs_in(wbs_execute),
      .mm_in(mm_execute),
      .ALUresult_in(output_execute), 
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
	decoderMemory decoderExecute_instance (
		.data_in(alu_result_memory),
      .select(mm_memory),
      .data_out_0(address_memory), 
      .data_out_1(write_register_Data_memory)
   );
	
	mux_2 mux_2_instance_memory (
      .data0(write_register_Data_memory),
      .data1(write_Data_memory), 
      .select(wm_memory),
      .out(output_memory_mux)
   );	

	RAM ram_datos_instance(
		.address(address_memory),
		.clock(clk),
		.data(16'b0),			
		.wren(wme_memory),  
		.q(mem_Data_memory)
	);	

	MemoryWriteback_register MemoryWriteback_register_instance (
      .clk(clk),
      .wbs_in(wbs_memory),
      .memData_in(mem_Data_memory),
      .calcData_in(output_memory_mux),
      .ni_in(ni_memory), 
		.reg_dest_in(reg_dest_memory),
      .wbs_out(wbs_writeback),
      .memData_out(mem_Data_writeback),
      .calcData_out(calcData_writeback),
      .ni_out(ni_writeback),
		.reg_dest_out(reg_dest_writeback)
   );
	

///////////// ETAPA WRITEBACK ////////////////////////////////////////////////////////////////////////////

	mux_2 mux_2_instance_writeback (
      .data0(readCoordinate_writeback),
      .data1(calcData_writeback), 
      .select(wbs_writeback),
      .out(wd3)
   );

	always #10 clk = ~clk;
	initial begin
		// Ciclo 1:
      $display("1 Primer ciclo ----------------------------------------------------------");
      // Asigna valores simulados para las entradas del DecodeExecute_register
      output_execute = 16'b0;//Resultado de la Alu
		wbs_execute = 1; 
		mm_execute = 2'b01;
		write_Data_execute = 16'b0;
      wm_execute = 1;
      ni_execute = 0;
		wme_execute = 1'b1;
		reg_dest_execute = 4'b000 ;
		alu_mux_execute = 0;
		alu_mux1_execute = 1;

		$display("\n \n \n");
		
		#20
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		// Ciclo 2:
      $display("2 Segungo ciclo ----------------------------------------------------------");
      // Asigna valores simulados para las entradas del DecodeExecute_register
      output_execute = 16'b1;//Resultado de la Alu
		wbs_execute = 1; 
		mm_execute = 2'b01;
		write_Data_execute = 16'b0;
      wm_execute = 1;
      ni_execute = 0;
		wme_execute = 1'b1;
		reg_dest_execute = 4'b000 ;
		alu_mux_execute = 1;
		alu_mux1_execute = 0;

		$display("\n \n \n");
		
		#20
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		// Ciclo 3:
      $display("3 tercer ciclo ----------------------------------------------------------");
      // Asigna valores simulados para las entradas del DecodeExecute_register
      output_execute = 16'b0;//Resultado de la Alu
		wbs_execute = 1; 
		mm_execute = 2'b00;
		write_Data_execute = 16'b1;
      wm_execute = 1;
      ni_execute = 1;
		wme_execute = 1'bx;
		reg_dest_execute = 4'b001 ;
		alu_mux_execute = 0;
		alu_mux1_execute = 1;

		$display("\n \n \n");
		#20
		////////////////////////////////////////////////////////////////////////////////////////////////////
      $finish;
    end
endmodule
