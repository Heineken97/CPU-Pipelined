module forwarding_unit (
    input logic [3:0] rs1_execute,
    input logic [3:0] rs2_execute,
    
    input logic [3:0] rd_memory,
    input logic [3:0] rd_writeback,
    input logic wre_memory,
    input logic wre_writeback,
    
    output logic [2:0] select_forward_mux_A,
    output logic [2:0] select_forward_mux_B
);

    always_comb begin
        // Lógica para seleccionar la señal del primer operando (rs1_execute)
        if (wre_memory && (rd_memory == rs1_execute)) begin
            select_forward_mux_A = 3'b010;
        end else if (wre_writeback && (rd_writeback == rs1_execute)) begin
            select_forward_mux_A = 3'b001;
        end else begin
            select_forward_mux_A = 3'b000;
        end
        
        // Lógica para seleccionar la señal del segundo operando (rs2_execute)
        if (wre_memory && (rd_memory == rs2_execute)) begin
            select_forward_mux_B = 3'b010;
        end else if (wre_writeback && (rd_writeback == rs2_execute) &&
                     !(wre_memory && (rd_memory == rs2_execute))) begin
            select_forward_mux_B = 3'b001;
        end else begin
            select_forward_mux_B = 3'b000;
        end
    end

endmodule
