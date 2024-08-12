module LogicalShiftLeft (
    input logic [15:0] data_in,
    input logic [15:0] shift_amount,
    output logic [15:0] shifted_data
);
	always_comb begin
		shifted_data = data_in << shift_amount;
	end
endmodule