module ALU (
    input logic [3:0] aluOp, // Entrada de control para la operación ALU
    input logic [15:0] srcA, // Primer operando
    input logic [15:0] srcB, // Segundo operando
    output logic [15:0] result // Resultado de la operación
);
	// Variables para almacenar los resultados de las operaciones
	logic [15:0] add_result, sub_result;
	// Instanciar los módulos adder y subtractor
	adder u_adder (
		.a(srcA),
		.b(srcB),
		.y(add_result)
	);
	// Selección de la operación basada en ALUop
	always_comb begin
		case (aluOp)
			4'b0000: result = 4'b0000; // nop/stall
			4'b0001: result = add_result; // Suma
			default: result = 16'h0000; // Manejo de caso inválido
      endcase
    end
endmodule
