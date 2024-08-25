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

	// unidad de control
	logic wre_decode;
	logic write_memory_enable_decode;
	logic [1:0] writeback_data_mux_decode;



	// mux de la unidad de control
	logic [6:0] nop_mux_output;
	logic [1:0] select_nop_mux;
	
	// banco de registros
	logic [15:0] writeback_data;
	
	// extensor de signo
	logic [15:0] extended_label;
	
	// sumador branch
	logic [15:0] pc_decode;
	
	
	

    // Interconexiones
    
    
    
	 
	 
	
	 
	 
	logic [15:0] ALUop_decode;
	logic [15:0] ALUop_execute;
	logic [15:0] rd1;
	logic [15:0] rd2;
	logic [15:0] rd3;
	
	logic [15:0] srcA_execute;
	logic [15:0] srcB_execute;
	
	logic [15:0] alu_result_execute;
	logic [15:0] alu_result_memory;
	
	
	
//////////////////////////////////////////////////////////////////////////////


// Inicialización
	pc_offset = 16'b0000000000000001;


	
	
	
	
//////////////////////////////////////////////////////////////////////////////



// sumador del PC
	adder pc_add (
        .a(pc_address),
        .b(pc_offset),
        .y(pc_incremented)
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
		  .pc(pc_address),
        .instruction_in(instruction_fetch),
		  .pc_decode(pc_decode),
        .instruction_out(instruction_decode)
    );
	
////////////////////////////////////////////////////////////////////////////////////////////////	
	 
	 controlUnit control_unit_instance (
      .opCode(instruction_decode[15:12]),
		.control_signals(control_signals)
    );
	 
// mux que elige entre las señales de control y los stalls
    mux_2inputs mux_2inputs_nop (
        .data0(7'b0),
        .data1(control_signals),
        .select(select_nop_mux),
        .out(nop_mux_output)
    );
	 
	 signExtend sign_extend_instance (
        .label(instruction_decode[11:8]),
        .SignExtLabel(extended_label) 
    );
	 
	 adder branch_label_pc_add (
        .a(pc_decode),
        .b(extended_label),
        .y(branch_address)
    );
	 
	 
	 
	 
	
	 
	 
	 Regfile_scalar regfile_instance (
      .clk(clk),
      .wre(wre xs xsas sxax),
      .a1(instruction_decode[3:0]),
      .a2(instruction_decode[7:4]),
      .a3(instruction_decode[11:8]),
      .wd3(writeback_data),
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
      .calcData_out(writeback_data)
   );

////////////////////////////////////////////////////////////////////////////////////////////////

	
	
	
endmodule
