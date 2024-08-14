module top (
    input logic clk,
    input logic reset,
    input logic select,
    input logic [15:0] offset,
    output logic [15:0] ROM_data
);
   // Interconexiones
   logic [15:0] pc_address;
   logic [15:0] pc_incremented;
   logic [15:0] mux_output;
	logic select_next_PC = 0;

	logic [15:0] read_addres_or_data;
	logic [15:0] write_Data_execute;
	logic [3:0] out_mux4, mux_output_2;
	logic [3:0] reg_dest_data_writeback;
	// Registro Fetch
	logic [15:0] instruction_fetch;
	logic [15:0] instruction_decode;
	// Senales de Control 
	logic wbs_decode; 
	logic mm_decode;
   logic [2:0] ALUop_decode;
	logic [1:0] ri;
	logic wre_decode;
   logic wm_decode;
   logic am_decode;
   logic ni_decode;
	logic wme_decode;
	logic alu_mux_decode,alu_mux1_decode;
	logic [3:0] reg_dest_decode;
	// Registro Execute
	logic [15:0] alu_result;
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
	//Extension de Signo	
	logic [15:0] SignExtImmediate;
	//Extension de Zero
	logic [15:0] ZeroExtImmediate;
	//Registros
	logic [15:0] rd1, rd2, rd3;
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
	logic wre_writeback;
	logic [15:0] mem_Data_writeback;
	logic [15:0] calcData_writeback;
	logic [15:0] data_writeback;

    // Instanciar el módulo PC_register
    PC_register pc_reg (
        .clk(clk),
        .reset(reset),
        .address_in(mux_output),
        .address_out(pc_address)
    );

    // Instanciar el módulo PC_adder
    PC_adder pc_add (
        .address(pc_address),
        .offset(offset),
        .PC(pc_incremented)
    );

    // Instanciar el módulo mux_2inputs
    mux_2inputs mux_2inputs_PC (
        .data0(pc_incremented),
        .data1(srcB_execute),
        .select(select_next_PC),
        .out(mux_output)
    );

    // Instanciar el módulo ROM
    ROM rom_memory (
        .address(pc_address),
        .clock(clk),
        .q(ROM_data)
    );
	 
	 //Instanciar Modulo de Etapa Fetch
	 FetchDecode_register FetchDecode_register_instance (
        .clk(clk),
		  .reset(reset),
        .instruction_in(instruction_fetch),
        .instruction_out(instruction_decode)
    );
	 
	 //Instanciar Unidad de Control
	 controlUnit control_unit_instance (
      .opCode(instruction_decode[15:12]),
		.selectNextPC(select_next_PC),
      .wbs(wbs_decode),
      .mm(mm_decode),
      .ALUop(ALUop_decode),
      .ri(ri),
      .wre(wre_decode),
      .wm(wm_decode),
      .am(am_decode),
      .ni(ni_decode),
		.wme(wme_decode),
		.alu_mux(alu_mux_decode),
		.alu_mux1(alu_mux1_decode),
		.rde(reg_dest_enable)
   );
	
	//Extension de signo
	signExtend signExtend_instance (
      .Immediate(instruction_decode[7:0]),
      .SignExtImmediate(SignExtImmediate)
   );
	
	//Extension de Zero
   zeroExtend zeroExtend_instance (
      .Immediate(instruction_decode[11:0]),
      .ZeroExtImmediate(ZeroExtImmediate)
   );
	
	//Mux
	mux_2inputs mux_2_regfile (
        .data0(instruction_decode[11:8]),
        .data1(reg_dest_data_writeback),
        .select(reg_dest_enable),		
        .out(mux_output_2)	
    );
	//Registros Escalares
   regfile regfile_instance (
      .clk(clk),
      .wre(wre_decode), 
      .a1(instruction_decode[3:0]),
      .a2(instruction_decode[7:4]),
      .a3(mux_output_2),
      .wd3(reg_dest_data_writeback),
      .rd1(rd1),
      .rd2(rd2),
      .rd3(rd3)
   );
	//Instancia de mux en 4 salidas
	mux_4 mux_4_instance (
      .data0(rd2),
      .data1(rd3),
      .data2(SignExtImmediate),
      .data3(ZeroExtImmediate),
      .select(ri),
      .out(out_mux4)
   );
///////////// REGISTRO PIPELINE DECODE-EXECUTE ///////////////////////////////////////////////////////////
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
		.srcA_in(rd1),
		.srcB_in(out_mux4),
		
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
///////////// REGISTRO PIPELINE EXECUTE-MEMORY ///////////////////////////////////////////////////////////
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
      .memData_out(data_writeback),
      .calcData_out(calcData_writeback),
      .ni_out(ni_writeback),
		.reg_dest_out(reg_dest_writeback)
   );
	
	mux_2 mux_2_instance_writeback (
      .data0(data_writeback),
      .data1(calcData_writeback), 
      .select(wbs_writeback),
      .out(reg_dest_data_writeback)
   );

endmodule
