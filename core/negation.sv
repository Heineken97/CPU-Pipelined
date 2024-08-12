module negation (
	input logic [15:0] data_in,
	output logic [15:0] negated_data
);
	assign negated_data = ~data_in + 1;
endmodule