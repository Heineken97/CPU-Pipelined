module mux_4 (
    input logic [15:0] data0, data1, data2, data3,
    input logic [1:0] select,
    output logic [15:0] out
);

    always_comb begin
        case (select)
            2'b00: out = data0; // Selecciona data0 si select es 00
            2'b01: out = data1; // Selecciona data1 si select es 01
            2'b10: out = data2; // Selecciona data2 si select es 10
            2'b11: out = data3; // Selecciona data3 si select es 11
            default: out = 16'hXXXX; // Manejo de caso inválido
        endcase
    end

endmodule