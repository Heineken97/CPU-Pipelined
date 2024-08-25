module PC_register (
    input logic clk, 
    input logic reset,
    input logic nop,
    input logic [15:0] address_in,
    output logic [15:0] address_out
);

    // Registro de almacenamiento de 16 bits
    logic [15:0] out = 0;

    // Proceso de escritura en el registro
    always_ff @(posedge clk) begin
        if (reset) begin
            out <= 16'b0; // Inicializar el registro en 0 cuando se active el reset
        end else if (!nop) begin
            out <= address_in; // Actualizar solo si nop es 0
        end
    end

    // Salida del registro
    assign address_out = out;

endmodule
