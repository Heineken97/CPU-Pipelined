module decoderMemory (
	input logic [15:0] data_in,
	input logic select,
	output logic [15:0] data_out_0,
	output logic [15:0] data_out_1
);
assign data_out_0 = select ? '0 : data_in;
assign data_out_1 = select ? data_in : '0;
endmodule