module regfile(
    input logic clk,
    input logic wre,
    input logic [3:0] a1, a2, a3,
    input logic [15:0] wd3,
    output logic [15:0] rd1, rd2, rd3
);

    // Vector con 12 registros de 16 bits cada uno, inicializados con valores diferentes
    logic [15:0] rf[11:0] = '{16'hC, 16'hB, 16'hA, 16'h9, 16'h8, 16'h7, 16'h6, 16'h5, 16'h4, 16'h3, 16'h2, 16'h1};

    // Escritura en el tercer puerto en el flanco positivo del reloj
    always_ff @(posedge clk)
        if (wre) rf[a3] <= wd3;

    // Lectura de los registros
    assign rd1 = rf[a1];
    assign rd2 = rf[a2];
    assign rd3 = rf[a3];

endmodule
