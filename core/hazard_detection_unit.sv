module hazard_detection_unit(
	 input logic [3:0] opcode,
    input logic [3:0] rd_load_execute,
    input logic load_instruction,
	 input logic [15:0] regfile_data_1,
	 input logic [15:0] regfile_data_2,
    input logic [3:0] rs1_decode,
    input logic [3:0] rs2_decode,
    input logic [3:0] rs1_execute,
    input logic [3:0] rs2_execute,
	 output logic [1:0] nop,
	 output logic [1:0] flush
);

always_comb begin
    nop = 2'b00; // Inicializa 'nop' en 0
	 flush = 2'b00; 
    if (load_instruction & ((rd_load_execute == rs2_decode) | (rd_load_execute == rs1_decode))) begin
		  flush = 2'b00; // poner en ceros el registro pipeline Fetch-Decode
        nop = 2'b01;		// hace un nop para el riesgo de datos de la instruccion de load ldr
    end
	 if ((opcode == 4'b0000)) begin
		  flush = 2'b00; 
		  nop = 2'b00;
    end
	 if ((opcode == 4'b0100) & (regfile_data_1 == regfile_data_1)) begin
		  flush = 2'b01;
		  nop = 2'b00;
    end
end

endmodule
