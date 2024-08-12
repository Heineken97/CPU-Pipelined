module mux_2inputs (
	input logic [3:0] data0,
	input logic	[3:0] data1,
	input logic select,
	output logic [3:0] out
);
	assign out = select ? data1 : data0;
endmodule
