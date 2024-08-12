module Decode_Stage_tb;
	logic clk = 0;
	logic reset = 0;
	// Interconexiones
   logic [3:0] mux_output_2;
	logic [15:0] out_mux4;
	logic [3:0] reg_dest_data_writeback = 4'b0010 ; // Para simulacion
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
	logic reg_dest_enable;
	// Registro Decode
	logic wbs_execute; 
	logic mm_execute;
   logic [2:0] ALUop_execute;
   logic wm_execute;
   logic am_execute;
   logic ni_execute;
	logic wme_execute;
	logic alu_mux_execute,alu_mux1_execute;
	logic reg_dest_execute;
	logic [15:0] srcA_execute;
	logic [15:0] srcB_execute;
	//Extension de Signo	
	logic [15:0] SignExtImmediate;
	//Extension de Zero
	logic [15:0] ZeroExtImmediate;
	//Registros
	logic [15:0] wd3 = 16'b0000000000000011; //Para efectos de simulacion;
	logic [15:0] rd1, rd2, rd3;
	 	 
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

     
   regfile regfile_instance (
      .clk(clk),
      .wre(wre_decode), 
      .a1(instruction_decode[3:0]),
      .a2(instruction_decode[7:4]),
      .a3(mux_output_2),
      .wd3(wd3),
      .rd1(rd1),
      .rd2(rd2),
      .rd3(rd3)
   );
	
	 
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

   always #10 clk = ~clk;
	initial begin
			
		instruction_fetch = 16'b0001000000010010; // add rd=0, rs1=1, rs2=2 Tipo R
		
		$display("\n *** 1 *** \n");
		$display("mov rd=1 inmediato=7 Tipo I \n");
		$display("Instruccion que viene de la memoria de instrucciones = %b", instruction_fetch);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Instruccion que sale del registro FETCH-DECODE = %b", instruction_decode);
		$display("Entradas de la unidad de control ---------------------------------------------------- \n");
		$display("Codigo de operacion = %b", instruction_decode[15:12]);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Salidas de la unidad de control ----------------------------------------------------- \n");
		$display("wbs: %b", wbs_decode);
		$display("wre: %b", wre_decode);
		$display("wm: %b", wm_decode);
		$display("mm: %b", mm_decode);
		$display("ALUop: %b", ALUop_decode);
		$display("ri: %b", ri);
		$display("wre: %b", wre_decode);
		$display("wm: %b", wm_decode);
		$display("am: %b", am_decode);
		$display("ni: %b", ni_decode);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Otras partes de la instruccion ------------------------------------------------------ \n");
		$display("RS1: %b", instruction_decode[3:0]);
		$display("RS2: %b", instruction_decode[7:4]);
		$display("RD: %b", instruction_decode[11:8]);
		$display("Inmediato del formato I: %b", instruction_decode[7:0]);
		$display("Extension de signo: %b", SignExtImmediate);
		$display("Inmediato del formato J: %b", instruction_decode[11:0]);
		$display("Extension de zero: %b", ZeroExtImmediate);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Banco de registros ------------------------------------------------------------------ \n");
		$display("WD3: %b", wd3);
		$display("RD1: %b", rd1);
		$display("RD2: %b", rd2);
		$display("RD3: %b", rd3);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Salida del mux ---------------------------------------------------------------------- \n");
		$display("out_mux4: %b", out_mux4);
		$display("------------------------------------------------------------------------------------- \n");
		$display("------------------------------------------------------------------------------------- \n");
		$display("Salidas del registro DECODE-EXECUTE (debe ir 1 ciclo atrasado)\n");
		$display("wbs: %b", wbs_execute);
		$display("wme: %b", wme_execute);
		$display("mm: %b", mm_execute);
		$display("ALUop: %b", ALUop_execute);
		$display("wm: %b", wm_execute);
		$display("am: %b", am_execute);
		$display("ni: %b", ni_execute);
		$display("src A: %b", srcA_execute);
		$display("src B: %b", srcB_execute);
		$display("\n \n \n");
		
		
		#20;
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		instruction_fetch = 16'b1000001000001001; // mov rd=2 inmediato=9 Tipo I
		
		$display("\n *** 2 *** \n");
		$display("mov rd=2 inmediato=9 Tipo I \n");
		$display("Instruccion que viene de la memoria de instrucciones = %b", instruction_fetch);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Instruccion que sale del registro FETCH-DECODE = %b", instruction_decode);
		$display("Entradas de la unidad de control ---------------------------------------------------- \n");
		$display("Codigo de operacion = %b", instruction_decode[15:12]);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Salidas de la unidad de control ----------------------------------------------------- \n");
		$display("wbs: %b", wbs_decode);
		$display("wre: %b", wre_decode);
		$display("wm: %b", wm_decode);
		$display("mm: %b", mm_decode);
		$display("ALUop: %b", ALUop_decode);
		$display("ri: %b", ri);
		$display("wre: %b", wre_decode);
		$display("wm: %b", wm_decode);
		$display("am: %b", am_decode);
		$display("ni: %b", ni_decode);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Otras partes de la instruccion ------------------------------------------------------ \n");
		$display("RS1: %b", instruction_decode[3:0]);
		$display("RS2: %b", instruction_decode[7:4]);
		$display("RD: %b", instruction_decode[11:8]);
		$display("Inmediato del formato I: %b", instruction_decode[7:0]);
		$display("Extension de signo: %b", SignExtImmediate);
		$display("Inmediato del formato J: %b", instruction_decode[11:0]);
		$display("Extension de zero: %b", ZeroExtImmediate);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Banco de registros ------------------------------------------------------------------ \n");
		$display("WD3: %b", wd3);
		$display("RD1: %b", rd1);
		$display("RD2: %b", rd2);
		$display("RD3: %b", rd3);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Salida del mux ---------------------------------------------------------------------- \n");
		$display("out_mux4: %b", out_mux4);
		$display("------------------------------------------------------------------------------------- \n");
		$display("------------------------------------------------------------------------------------- \n");
		$display("Salidas del registro DECODE-EXECUTE (debe ir 1 ciclo atrasado)\n");
		$display("wbs: %b", wbs_execute);
		$display("wm: %b", wm_execute);
		$display("mm: %b", mm_execute);
		$display("ALUop: %b", ALUop_execute);
		$display("wm: %b", wm_execute);
		$display("am: %b", am_execute);
		$display("ni: %b", ni_execute);
		$display("src A: %b", srcA_execute);
		$display("src B: %b", srcB_execute);
		$display("\n \n \n");
		
		
		#20;
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		instruction_fetch = 16'b1000000100000111; // mov rd=1 inmediato=7 Tipo I		
		
		$display("\n *** 3 *** \n");
		$display("add rd=0, rs1=1, rs2=2 Tipo R \n");
		$display("Instruccion que viene de la memoria de instrucciones = %b", instruction_fetch);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Instruccion que sale del registro FETCH-DECODE = %b", instruction_decode);
		$display("Entradas de la unidad de control ---------------------------------------------------- \n");
		$display("Codigo de operacion = %b", instruction_decode[15:12]);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Salidas de la unidad de control ----------------------------------------------------- \n");
		$display("wbs: %b", wbs_decode);
		$display("wre: %b", wre_decode);
		$display("wm: %b", wm_decode);
		$display("mm: %b", mm_decode);
		$display("ALUop: %b", ALUop_decode);
		$display("ri: %b", ri);
		$display("wre: %b", wre_decode);
		$display("wm: %b", wm_decode);
		$display("am: %b", am_decode);
		$display("ni: %b", ni_decode);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Otras partes de la instruccion ------------------------------------------------------ \n");
		$display("RS1: %b", instruction_decode[3:0]);
		$display("RS2: %b", instruction_decode[7:4]);
		$display("RD: %b", instruction_decode[11:8]);
		$display("Inmediato del formato I: %b", instruction_decode[7:0]);
		$display("Extension de signo: %b", SignExtImmediate);
		$display("Inmediato del formato J: %b", instruction_decode[11:0]);
		$display("Extension de zero: %b", ZeroExtImmediate);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Banco de registros ------------------------------------------------------------------ \n");
		$display("WD3: %b", wd3);
		$display("RD1: %b", rd1);
		$display("RD2: %b", rd2);
		$display("RD3: %b", rd3);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Salida del mux ---------------------------------------------------------------------- \n");
		$display("out_mux4: %b", out_mux4);
		$display("------------------------------------------------------------------------------------- \n");
		$display("------------------------------------------------------------------------------------- \n");
		$display("Salidas del registro DECODE-EXECUTE (debe ir 1 ciclo atrasado)\n");
		$display("wbs: %b", wbs_execute);
		$display("wm: %b", wm_execute);
		$display("mm: %b", mm_execute);
		$display("ALUop: %b", ALUop_execute);
		$display("wm: %b", wm_execute);
		$display("am: %b", am_execute);
		$display("ni: %b", ni_execute);
		$display("src A: %b", srcA_execute);
		$display("src B: %b", srcB_execute);
		$display("\n \n \n");
		
		
		#20;
		////////////////////////////////////////////////////////////////////////////////////////////////////
		
		instruction_fetch = 16'b0101000000000101; // bgt address=5 Tipo J
		
		$display("\n *** 4 *** \n");
		$display("bgt address=5 Tipo J \n");
		$display("Instruccion que viene de la memoria de instrucciones = %b", instruction_fetch);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Instruccion que sale del registro FETCH-DECODE = %b", instruction_decode);
		$display("Entradas de la unidad de control ---------------------------------------------------- \n");
		$display("Codigo de operacion = %b", instruction_decode[15:12]);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Salidas de la unidad de control ----------------------------------------------------- \n");
		$display("wbs: %b", wbs_decode);
		$display("wre: %b", wre_decode);
		$display("wm: %b", wm_decode);
		$display("mm: %b", mm_decode);
		$display("ALUop: %b", ALUop_decode);
		$display("ri: %b", ri);
		$display("wre: %b", wre_decode);
		$display("wm: %b", wm_decode);
		$display("am: %b", am_decode);
		$display("ni: %b", ni_decode);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Otras partes de la instruccion ------------------------------------------------------ \n");
		$display("RS1: %b", instruction_decode[3:0]);
		$display("RS2: %b", instruction_decode[7:4]);
		$display("RD: %b", instruction_decode[11:8]);
		$display("Inmediato del formato I: %b", instruction_decode[7:0]);
		$display("Extension de signo: %b", SignExtImmediate);
		$display("Inmediato del formato J: %b", instruction_decode[11:0]);
		$display("Extension de zero: %b", ZeroExtImmediate);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Banco de registros ------------------------------------------------------------------ \n");
		$display("WD3: %b", wd3);
		$display("RD1: %b", rd1);
		$display("RD2: %b", rd2);
		$display("RD3: %b", rd3);
		$display("------------------------------------------------------------------------------------- \n");
		$display("Salida del mux ---------------------------------------------------------------------- \n");
		$display("out_mux4: %b", out_mux4);
		$display("------------------------------------------------------------------------------------- \n");
		$display("------------------------------------------------------------------------------------- \n");
		$display("Salidas del registro DECODE-EXECUTE (debe ir 1 ciclo atrasado)\n");
		$display("wbs: %b", wbs_execute);
		$display("wme: %b", wme_execute);
		$display("mm: %b", mm_execute);
		$display("ALUop: %b", ALUop_execute);
		$display("wm: %b", wm_execute);
		$display("am: %b", am_execute);
		$display("ni: %b", ni_execute);
		$display("src A: %b", srcA_execute);
		$display("src B: %b", srcB_execute);
		$display("\n \n \n");
		#20;				
		$finish;
	end
endmodule