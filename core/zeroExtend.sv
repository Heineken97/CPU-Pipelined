module zeroExtend (
    input logic [7:0] Immediate,
    output logic [15:0] ZeroExtImmediate
);
    assign ZeroExtImmediate = { {8'b0}, Immediate };
endmodule