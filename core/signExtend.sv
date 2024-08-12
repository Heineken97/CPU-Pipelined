module signExtend (
    input logic [7:0] Immediate,
    output logic [15:0] SignExtImmediate
);
    assign SignExtImmediate = { {8{Immediate[7]}}, Immediate };
endmodule