module controlUnit (
    input logic [3:0] opCode,
	 output logic [6:0] control_signals // salida concatenada
);

	 logic wre,	// write register enable
	 logic [3:0] aluOp,	// operacion que debe realizar la ALU
	 logic write_memory_enable, // indica si la operacion escribe o no en la memoria
	 logic writeback_data_mux // mux que elige entre el dato calculado en la alu o el dato que sale de memoria
	 

    // Definición de las salidas en función del opCode
    always_comb begin
        case (opCode)
		  
				// nop/stall
            4'b0000: begin
                wre = 1'b0;
					 aluOp = 4'b0000;
					 write_memory_enable = 1'b0;
					 writeback_data_mux = 1'b0;
            end
            
				// add
            4'b0001: begin
                wre = 1'b1;
					 aluOp =4'b0001;
					 write_memory_enable = 1'b0;
					 writeback_data_mux = 1'b1;
            end
				
				// str
            4'b1010: begin
                wre = 1'b0;
					 aluOp =4'b0000;
					 write_memory_enable = 1'b1;
					 writeback_data_mux = 1'b0;
            end
				
				// ldr
            4'b1001: begin
                wre = 1'b1;
					 aluOp =4'b0001;
					 write_memory_enable = 1'b0;
					 writeback_data_mux = 1'b1;
            end
				
				// be
            4'b0100: begin
                wre = 1'b0;
					 aluOp =4'b0000;
					 write_memory_enable = 1'b0;
					 writeback_data_mux = 1'b0;
            end
            
            
            default: begin
                wre = 1'b0;
					 aluOp =4'b0000;
					 write_memory_enable = 1'b0;
					 writeback_data_mux = 1'b0;
            end
        endcase
		  
		  // Concatenación de las señales de control para que sea la entrada al mux de stalls
		  control_signals = {wre, write_memory_enable, writeback_data_mux, aluOp};

    end

endmodule
