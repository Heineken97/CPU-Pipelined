module FetchDecode_register (
    input logic clk,
    input logic reset,
    input logic nop,
    input logic [15:0] instruction_in,
    output logic [15:0] instruction_out
);

    // Registro de almacenamiento de 16 bits
    logic [15:0] out;

    // Proceso de escritura en el registro
    always_ff @(posedge clk) begin
        if (reset) begin
            out <= 16'b0; // Inicializar el registro a 0 cuando se activa el reset
        end else if (nop) begin
            out <= 16'b0; // Si nop es 1, la salida es 0
        end else begin
            out <= instruction_in; // actualizar la instruction
        end
    end

    // Salida del registro
    assign instruction_out = out;

endmodule
