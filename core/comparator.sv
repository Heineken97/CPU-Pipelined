module comparator (
	input logic [15:0] num1,
	input logic [15:0] num2,
	output logic [15:0] result
);
	assign result = (num1 == num2) ? 16'b0000000000000000 : (num1 > num2) ? 16'b0000000000000001 : 16'b0000000000000010;
endmodule