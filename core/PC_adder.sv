module PC_adder (
	input logic [15:0] address,
	input logic [15:0] offset,
	output logic [15:0] PC
);

	assign PC = address + offset;
	
endmodule
