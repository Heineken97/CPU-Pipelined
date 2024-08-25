module top (
    input logic clk,
    input logic reset
);

	// registro PC
	logic [15:0] pc_mux_output;
	logic [15:0] pc_address;
	logic nop;

	// sumador del PC
	logic [15:0] pc_offset;
	logic [15:0] pc_incremented;
	
	
	// mux del PC
	logic [1:0] select_pc_mux;   // esta señal de control viene del comparador entre rs1 y rs2
	logic [15:0] branch_address;

	// registro Fetch-Decode
	logic [15:0] instruction_fetch;
	logic [15:0] instruction_decode;








    // Interconexiones
    
    
    
	 
	 
	
	 
	 logic wre;
	logic [15:0] ALUop_decode;
	logic [15:0] ALUop_execute;
	logic [15:0] rd1;
	logic [15:0] rd2;
	logic [15:0] rd3;
	
	logic [15:0] srcA_execute;
	logic [15:0] srcB_execute;
	
	logic [15:0] alu_result_execute;
	logic [15:0] alu_result_memory;
	
	logic [15:0] calcData_writeback;
	
//////////////////////////////////////////////////////////////////////////////


// Inicialización
	pc_offset = 16b'1;

	
	
	
	
//////////////////////////////////////////////////////////////////////////////



// sumador del PC
	PC_adder pc_add (
        .address(pc_address),
        .offset(pc_offset),
        .PC(pc_incremented)
    );
	 
// mux que elige entre el PC+1 o un branch
    mux_2inputs mux_2inputs_PC (
        .data0(pc_incremented),
        .data1(branch_address),
        .select(select_pc_mux),
        .out(pc_mux_output)
    );
	 
	 PC_register pc_reg (
        .clk(clk),
        .reset(reset),
		  .nop(nop),
        .address_in(pc_mux_output),
        .address_out(pc_address)
    );

    

    

    ROM rom_memory (
        .address(pc_address),
        .clock(clk),
        .q(instruction_fetch)
    );
	 
////////////////////////////////////////////////////////////////////////////////////////////////

	 FetchDecode_register FetchDecode_register_instance (
        .clk(clk),
		  .reset(reset),
		  .nop(nop),
        .instruction_in(instruction_fetch),
        .instruction_out(instruction_decode)
    );
	
////////////////////////////////////////////////////////////////////////////////////////////////	
	 
	 
	 
	 
	 
	 
	 
	 
	 	controlUnit control_unit_instance (
      .opCode(instruction_decode[15:12]),
		 .wre(wre),
      .aluOp(ALUop_decode)     
    );
	 
	 
	 Regfile_scalar regfile_instance (
      .clk(clk),
      .wre(wre),
      .a1(instruction_decode[3:0]),
      .a2(instruction_decode[7:4]),
      .a3(instruction_decode[11:8]),
      .wd3(calcData_writeback),
      .rd1(rd1),
      .rd2(rd2),
      .rd3(rd3)
   );
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
////////////////////////////////////////////////////////////////////////////////////////////////

	 DecodeExecute_register DecodeExecute_register_instance (
		.clk(clk),
		.reset(reset),
      .aluOp_in(ALUop_decode),
      .srcA_in(rd1),
		.srcB_in(rd2),
		.aluOp_out(ALUop_execute),
      .srcA_out(srcA_execute),
		.srcB_out(srcB_execute)
   );
          
////////////////////////////////////////////////////////////////////////////////////////////////

	ALU ALU_instance (
      .aluOp(ALUop_execute),       
      .srcA(srcA_execute),
      .srcB(srcB_execute),
      .result(alu_result_execute)
   );




////////////////////////////////////////////////////////////////////////////////////////////////

	  ExecuteMemory_register ExecuteMemory_register_instance (
		.clk(clk),
		.reset(reset),
      .ALUresult_in(alu_result_execute),
      .ALUresult_out(alu_result_memory)
   );

////////////////////////////////////////////////////////////////////////////////////////////////








////////////////////////////////////////////////////////////////////////////////////////////////

	 MemoryWriteback_register MemoryWriteback_register_instance (
      .clk(clk),
		.reset(reset),
      .calcData_in(alu_result_memory),
      .calcData_out(calcData_writeback)
   );

////////////////////////////////////////////////////////////////////////////////////////////////

	
	
	
endmodule
