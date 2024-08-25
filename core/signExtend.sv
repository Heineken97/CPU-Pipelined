module signExtend (
    input logic [3:0] label,
    output logic [15:0] SignExtLabel
);
    assign SignExtLabel = { {8{label[7]}}, label };
endmodule
