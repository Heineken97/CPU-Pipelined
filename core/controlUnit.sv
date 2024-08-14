module controlUnit (
    input logic [3:0] opCode, // Codigo de Operacion instruccion
	 output logic selectNextPC,// IncrementarPC
    output logic wbs,			// writeback source
    output logic mm,				// memory or mov
    output logic [2:0] ALUop, // Codigo de Operacion ALU
    output logic [1:0] ri,		// register or immediate
    output logic wre,			// write register enable
	 output logic wm,				// write or mov
	 output logic am,				// address or mov
	 output logic ni,				// next instruction
	 output logic wme,			// write memory enable Data
	 output logic alu_mux,		// alu_result vs read_address_or_data 
	 output logic alu_mux1,		// srcA vs alu_result
	 output logic rde				// register destiny enable
);
	// Definición de las salidas en función del opCode
	always_comb begin
		selectNextPC= 1'bx;
		wbs = 1'bx;
		mm = 1'bx;
		ALUop = 3'bxxx;
		ri = 2'bxx;
		wre = 1'bx;
		wm = 1'bx;
		am = 1'bx;
		ni = 1'bx;
		wme = 1'bx;
		alu_mux = 1'bx;
		alu_mux1 = 1'bx;
		rde = 1'bx;
		case (opCode)
			// sub
			4'b0000: begin
				selectNextPC= 1'b0;	//Uso del Siguiente en PC
				wbs = 1'b1; 			//Uso de CalcData no de MemData
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'b000;	
            ri = 2'b00;				//Usa el RD2 de RegisterFile
            wre = 1'b1;				//Usa RegisterFile
				wm = 1'b0;				//Usa WriteRegisterData
				am = 1'bx;				//No aplica Address or Mov
				ni = 1'b0;				//Siguiente instruccion del PC y no JumpAddress
				wme = 1'bx;				//No aplica escritura en Memoria
				alu_mux =1'b0;			//Uso de Alu_result no de read
				alu_mux1 =1'b1;		//Uso de Alu_result no de srcA
				rde =1'b0;			   //Activa rd de instruccion
			end
			// add
         4'b0001: begin
				selectNextPC= 1'b0;	//Uso del Siguiente en PC
            wbs = 1'b1;
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'b001;
            ri = 2'b00;				//Usa el RD2 de RegisterFile
            wre = 1'b1;				//Usa RegisterFile
				wm = 1'b0;				//Usa WriteRegisterData
				am = 1'bx;				//No aplica Address or Mov
				ni = 1'b0;				//Siguiente instruccion del PC y no JumpAddress
				wme = 1'bx;				//No aplica escritura en Memoria
				alu_mux =1'b0;			//Uso de Alu_result no de read
				alu_mux1 =1'b1;		//Uso de Alu_result no de srcA
				rde =1'b0;			   //Activa rd de instruccion
         end
			// lsl
         4'b0010: begin
				selectNextPC= 1'b0;	//Uso del Siguiente en PC
            wbs = 1'b1;
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'b010;
            ri = 2'b11;				//Usa el Extension de Cero
            wre = 1'b1;				//Usa RegisterFile
				wm = 1'b0;				//Usa WriteRegisterData
				am = 1'bx;				//No aplica Address or Mov
				ni = 1'b0;				//Siguiente instruccion del PC y no JumpAddress
				wme = 1'bx;				//No aplica escritura en Memoria
				alu_mux =1'b0;			//Uso de Alu_result no de read
				alu_mux1 =1'b1;		//Uso de Alu_result no de srcA
				rde =1'b0;			   //Activa rd de instruccion
         end	
			// neg
			4'b0011: begin
				selectNextPC= 1'b0;	//Uso del Siguiente en PC
            wbs = 1'b1;
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'b011;
            ri = 2'b10;
            wre = 1'b1;
				wm = 1'b0;
				am = 1'bx;
				ni = 1'b0;
				wme = 1'bx;
				alu_mux =1'b0;			//Uso de Alu_result no de read
				alu_mux1 =1'b1;		//Uso de Alu_result no de srcA
				rde =1'b0;			   //Activa rd de instruccion
         end	
			// beq
			4'b0100: begin
				selectNextPC= 1'b0;	//Uso del Siguiente en PC
            wbs = 1'bx;
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'bxxx;
            ri = 2'b01;
            wre = 1'b0;
				wm = 1'bx;
				am = 1'bx;
				ni = 1'b0;
				wme = 1'bx;
				alu_mux =1'b0;			//Uso de Alu_result no de read
				alu_mux1 =1'b1;		//Uso de Alu_result no de srcA
				rde =1'b0;			   //Activa rd de instruccion
         end  
			// bgt
         4'b0101: begin
				selectNextPC= 1'b0;	//Uso del Siguiente en PC
            wbs = 1'bx;
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'bxxx;
            ri = 2'b11;
            wre = 1'b0;
				wm = 1'bx;
				am = 1'bx;
				ni = 1'b0;
				wme = 1'bx;
				alu_mux =1'b0;			//Uso de Alu_result no de read
				alu_mux1 =1'b1;		//Uso de Alu_result no de srcA
				rde =1'b0;			   //Activa rd de instruccion
         end
			// blt
         4'b0110: begin
				selectNextPC= 1'b0;	//Uso del Siguiente en PC
            wbs = 1'bx;
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'bxxx;
            ri = 2'b11;
            wre = 1'b0;
				wm = 1'bx;
				am = 1'bx;
				ni = 1'b0;
				wme = 1'bx;
				alu_mux =1'bx;
				rde =1'b0;			   //Activa rd de instruccion
         end
			// b
			4'b0111: begin
				selectNextPC= 1'b0;	//Uso del Siguiente en PC
            wbs = 1'bx;
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'bxxx;
            ri = 2'b11;
            wre = 1'b0;
				wm = 1'bx;
				am = 1'bx;
				ni = 1'b0;
				wme = 1'bx;
				alu_mux =1'b0;			//Uso de Alu_result no de read
				alu_mux1 =1'b1;		//Uso de Alu_result no de srcA
				rde =1'b0;			   //Activa rd de instruccion
         end
			// movi
			4'b1000: begin
				selectNextPC= 1'b1;	//Uso del jumpAddress
            wbs = 1'b1;
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'bxxx;
            ri = 2'b10;
            wre = 1'b1;
				wm = 1'b0;			
				am = 1'b1;
				ni = 1'b0;
				wme = 1'bx;
				alu_mux =1'b0;			//Uso de Alu_result no de read
				alu_mux1 =1'b1;		//Uso de Alu_result no de srcA
				rde =1'b0;			   //Activa rd de instruccion
         end
			// ldr
         4'b1001: begin
				selectNextPC= 1'b1;	//Uso del jumpAddress
            wbs = 1'b0;
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'b100;
            ri = 2'b10;
            wre = 1'b1;
				wm = 1'b1;
				am = 1'b0;
				ni = 1'b0;
				wme = 1'bx;
				alu_mux =1'b0;			//Uso de Alu_result no de read
				alu_mux1 =1'b1;		//Uso de Alu_result no de srcA
				rde =1'b0;			   //Activa rd de instruccion
         end
			// str
         4'b1010: begin
				selectNextPC= 1'b1;	//Uso del jumpAddress
            wbs = 1'bx;
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'b100;
            ri = 2'b10;
            wre = 1'b1;
				wm = 1'bx;
				am = 1'b1;
				ni = 1'b0;
				wme = 1'b1;
				alu_mux =1'b0;			//Uso de Alu_result no de read
				alu_mux1 =1'b1;		//Uso de Alu_result no de srcA
				rde =1'b1;			   //Activa rd de writeback
         end
			// cmp
			4'b1011: begin
				selectNextPC= 1'b0;	//Uso del Siguiente en PC
            wbs = 1'b1;
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'b101;
            ri = 2'b00;
            wre = 1'b1;
				wm = 1'b0;
				am = 1'bx;
				ni = 1'b0;
				wme = 1'bx;
				alu_mux =1'b0;			//Uso de Alu_result no de read
				alu_mux1 =1'b1;		//Uso de Alu_result no de srcA
				rde =1'b0;			   //Activa rd de instruccion
         end
			// movr
			4'b1100: begin
				selectNextPC= 1'b1;	//Uso del jumpAddress
            wbs = 1'b1;
            mm = 1'b0;				//No pasa por memoria de datos
            ALUop = 3'b011;
            ri = 2'b00;
            wre = 1'b1;
				wm = 1'b0;
				am = 1'bx;
				ni = 1'b0;
				wme = 1'bx;
				alu_mux =1'b0;			//Uso de Alu_result no de read
				alu_mux1 =1'b1;		//Uso de Alu_result no de srcA
				rde =1'b0;			   //Activa rd de writedata
         end
            
			////////////////////// NO HA SIDO ASIGNADO //////////////////////
         4'b1101: begin
				selectNextPC= 1'bx;	
				wbs = 1'bx;
            mm = 1'bx;
            ALUop = 3'bxxx;
            ri = 2'bxx;
            wre = 1'bx;
				wm = 1'bx;
				am = 1'bx;
				ni = 1'bx; 
				wme = 1'bx;
				alu_mux =1'bx;	
				alu_mux1 =1'bx;
				rde =1'bx;			   		
         end
         4'b1110: begin
				selectNextPC= 1'bx;	
            wbs = 1'bx;
            mm = 1'bx;	
            ALUop = 3'bxxx;
            ri = 2'bxx;
            wre = 1'bx;
				wm = 1'bx;
				am = 1'bx;
				ni = 1'bx;
				wme = 1'bx;
				alu_mux =1'bx;		
				alu_mux1 =1'bx;
				rde =1'bx;		
         end
			4'b1111: begin
				selectNextPC= 1'bx;
            wbs = 1'bx;
            mm = 1'bx;				
            ALUop = 3'bxxx;
            ri = 2'bxx;
            wre = 1'bx;
				wm = 1'bx;
				am = 1'bx;
				ni = 1'b0;
				wme = 1'bx;
				alu_mux =1'bx;			
				alu_mux1 =1'bx;
				rde =1'bx;		
         end
            
         default: begin
				selectNextPC= 1'bx;
				wbs = 1'bx;
            mm = 1'bx;
            ALUop = 3'bxxx;
            ri = 2'bxx;
            wre = 1'bx;
				wm = 1'bx;
				am = 1'bx;
				ni = 1'bx;
				wme = 1'bx;
				alu_mux =1'bx;			
				alu_mux1 =1'bx;
				rde =1'bx;		
         end
		endcase
	end
endmodule
