module controlUnit (
    input logic [3:0] opCode,
	 output logic [15:0] control_signals // salida concatenada
);
	logic wre;	// write register enable
	logic [3:0] aluOp;	// operacion que debe realizar la ALU
	logic write_memory_enable ; // indica si la operacion escribe o no en la memoria
	logic [1:0] select_writeback_data_mux; // mux que elige entre el dato calculado en la alu o el dato que sale de memoria
	// Definición de las salidas en función del opCode
	always_comb begin
		case (opCode)		  
			// nop/stall
			4'b0000: begin
				wre = 1'b0;
				write_memory_enable = 1'b0;
				select_writeback_data_mux = 2'b00;
				aluOp = 4'b0000;
			end
			// add
			4'b0001: begin
				wre = 1'b1;
				write_memory_enable = 1'b0;
				select_writeback_data_mux = 2'b01;
				aluOp =4'b0001;
			end	
			// str
			4'b1010: begin
				wre = 1'b0;
				write_memory_enable = 1'b1;
				select_writeback_data_mux = 2'b00;
				aluOp =4'b0000;
			end
			// ldr
			4'b1001: begin
				wre = 1'b1;
				write_memory_enable = 1'b0;
				select_writeback_data_mux = 2'b00;
				aluOp =4'b0001;
			end
			// beq
			4'b0100: begin
				wre = 1'b0;
				write_memory_enable = 1'b0;
				select_writeback_data_mux = 2'b00;
				aluOp =4'b0000;
			end
			default: begin
				wre = 1'b0;
				write_memory_enable = 1'b0;
				select_writeback_data_mux = 2'b00;
				aluOp =4'b0000;
			end
		endcase
		control_signals = {8'b0, wre, write_memory_enable, select_writeback_data_mux, aluOp};
	end
endmodule
