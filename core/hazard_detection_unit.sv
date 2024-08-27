module hazard_detection_unit(
    input logic [3:0] rd_load_execute,
    input logic write_memory_enable_execute,
    input logic [3:0] rs1_decode,
    input logic [3:0] rs2_decode,
    input logic [3:0] rs1_execute,
    input logic [3:0] rs2_execute,
    output logic [1:0] nop
);

always_comb begin
    nop = 0; // Inicializa 'nop' en 0
    if (write_memory_enable_execute & ((rs2_execute == rs1_decode) | (rs2_execute == rs2_decode))) begin
        nop = 1;
    end
end

endmodule
