module top (
    input logic clk,
    input logic reset
);
	//logic nop;

	// registro PC
	logic [15:0] pc_mux_output;
	logic [15:0] pc_address;

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
	//logicwre_decode;
	logic [15:0] control_signals;


	// mux de la unidad de control
	logic [15:0] nop_mux_output;
	logic select_nop_mux;
	
	// banco de registros
	logic [15:0] writeback_data;
	logic wre_writeback;
	logic [15:0] rd1;
	logic [15:0] rd2;
	logic [15:0] rd3;
	
	// extensor de signo
	logic [15:0] extended_label;
	
	// sumador branch
	logic [15:0] pc_decode;
	
	// registro Decode-Execute
	//logic wre_execute;
	logic write_memory_enable_execute;
	logic [1:0] select_writeback_data_mux_execute;
	logic [3:0] aluOp_execute;
	logic [3:0] rs1_execute; // entrada a la unidad de adelantamiento y de deteccion de riesgos
	logic [3:0] rs2_execute; // entrada a la unidad de adelantamiento y de deteccion de riesgos
	logic [3:0] rd_execute; 
	
	// alu
	logic [15:0] alu_src_A;
	logic [15:0] alu_src_B;
	logic [15:0] alu_result_execute;
	
	// mux's de la alu
	logic [15:0] srcA_execute;
	logic [15:0] srcB_execute;
	
	// registro Execute-Memory
	logic wre_memory;
	logic [1:0] select_writeback_data_mux_memory;
	logic write_memory_enable_memory;
	logic [15:0] alu_result_memory;
	logic [15:0] srcA_memory;
	logic [15:0] srcB_memory;
	logic [3:0] rd_memory;
		
	
	// unidad de adelantamiento
	logic [2:0] select_forward_mux_A;
	logic [2:0] select_forward_mux_B;
	
	// memoria de datos
	logic [15:0] data_from_memory;
	
	// registro Memory-Writeback
	logic [15:0] data_from_memory_writeback;
	logic [15:0] alu_result_writeback;
	logic [3:0] rd_writeback;
    	
//////////////////////////////////////////////////////////////////////////////

// Inicialización
	assign pc_offset = 16'b0000000000000001;
	
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
		  .nop(select_nop_mux),
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
		  .nop(select_nop_mux),
		  .pc(pc_address),
        .instruction_in(instruction_fetch),
		  .pc_decode(pc_decode),
        .instruction_out(instruction_decode)
    );
	
////////////////////////////////////////////////////////////////////////////////////////////////	
	 
	 hazard_detection_unit u_hazard_detection (
		 .rd_load_execute(rd_execute),
		 .write_memory_enable_execute(write_memory_enable_execute),
		 .rs1_decode(instruction_decode[3:0]),
		 .rs2_decode(instruction_decode[7:4]),
		 .rs1_execute(rs1_execute),
		 .rs2_execute(rs2_execute),
		 .nop(select_nop_mux)
	);
		 
	 controlUnit control_unit_instance (
      .opCode(instruction_decode[15:12]),
		.control_signals(control_signals)
    );
	 
// mux que elige entre las señales de control y los stalls
    mux_2inputs mux_2inputs_nop (
        .data0(control_signals),
        .data1(16'b0),
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
      .wre(wre_writeback),
      .a1(instruction_decode[3:0]),
      .a2(instruction_decode[7:4]),
      .a3(rd_writeback),
      .wd3(writeback_data),
      .rd1(rd1),
      .rd2(rd2),
      .rd3(rd3)
   );
	 
	comparator_branch comparator_instance (
		.opCode(instruction_decode[15:12]),
      .rs1_value(rd1),
      .rs2_value(rd2),
      .select_pc_mux(select_pc_mux)
	);  
	 
////////////////////////////////////////////////////////////////////////////////////////////////

	 DecodeExecute_register DecodeExecute_register_instance (
		.clk(clk),
		.reset(reset),
      .nop_mux_output_in(nop_mux_output),
      .srcA_in(rd1),
		.srcB_in(rd2),
		.rs1_decode(instruction_decode[3:0]),
		.rs2_decode(instruction_decode[7:4]),
		.rd_decode(instruction_decode[11:8]),
		.wre_execute(control_signals[9]),
      .write_memory_enable_execute(write_memory_enable_execute),
      .select_writeback_data_mux_execute(select_writeback_data_mux_execute),
      .aluOp_execute(aluOp_execute),
      .srcA_out(srcA_execute),
		.srcB_out(srcB_execute),
		.rs1_execute(rs1_execute),  // entrada a la unidad de adelantamiento
		.rs2_execute(rs2_execute), // entrada a la unidad de adelantamiento
		.rd_execute(rd_execute) 
   );
          
////////////////////////////////////////////////////////////////////////////////////////////////

	 mux_3inputs mux_alu_forward_A (
        .data0(srcA_execute),
        .data1(writeback_data),
        .data2(alu_result_memory),
        .select(select_forward_mux_A),
        .out(alu_src_A)
    );
	 
	 mux_3inputs mux_alu_forward_B (
        .data0(srcB_execute),
        .data1(writeback_data),
        .data2(alu_result_memory),
        .select(select_forward_mux_B),
        .out(alu_src_B)
    );

	ALU ALU_instance (
      .aluOp(aluOp_execute),       
      .srcA(alu_src_A),
      .srcB(alu_src_B),
      .result(alu_result_execute)
   );

////////////////////////////////////////////////////////////////////////////////////////////////

	  ExecuteMemory_register ExecuteMemory_register_instance (
		.clk(clk),
		.reset(reset),
      .wre_execute(wre_execute),
	   .select_writeback_data_mux_execute(select_writeback_data_mux_execute),
	   .write_memory_enable_execute(write_memory_enable_execute),
      .ALUresult_in(alu_result_execute),
	   .srcA_execute(srcA_execute),
	   .srcB_execute(srcB_execute),
	   .rd_execute(rd_execute),
	   .wre_memory(wre_memory),
	   .select_writeback_data_mux_memory(select_writeback_data_mux_memory),
	   .write_memory_enable_memory(write_memory_enable_memory),
	   .ALUresult_out(alu_result_memory),
	   .srcA_memory(srcA_memory),
	   .srcB_memory(srcB_memory),
	   .rd_memory(rd_memory)
   );

////////////////////////////////////////////////////////////////////////////////////////////////

	RAM RAM_instance(
		.address(srcA_memory),
		.clock(clk),
		.data(srcB_memory),
		.wren(write_memory_enable_memory),  
		.q(data_from_memory)
	);

////////////////////////////////////////////////////////////////////////////////////////////////

	 MemoryWriteback_register MemoryWriteback_register_instance (
      .clk(clk),
		.reset(reset),
      .wre_memory(wre_memory),
      .select_writeback_data_mux_memory(select_writeback_data_mux_memory),
      .rd_memory(rd_memory), 
      .data_from_memory_in(data_from_memory),
      .calc_data_in(alu_result_memory),
    
      .data_from_memory_out(data_from_memory_writeback),
      .calc_data_out(alu_result_writeback),
      .wre_writeback(wre_writeback),
      .select_writeback_data_mux_writeback(),
      .rd_writeback(rd_writeback)
   );

////////////////////////////////////////////////////////////////////////////////////////////////

	mux_2inputs mux_2inputs_writeback (
        .data0(data_from_memory_writeback),
        .data1(alu_result_writeback),
        .select(select_writeback_data_mux_writeback),
        .out(writeback_data)
    );
	
	
endmodule
