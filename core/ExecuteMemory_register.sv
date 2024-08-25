module ExecuteMemory_register (
    input logic clk,
    input logic reset,
    input logic wre_execute,
    input logic select_writeback_data_mux_execute,
    input logic write_memory_enable_execute,
    input logic [15:0] ALUresult_in,
    input logic [15:0] srcA_execute,
    input logic [15:0] srcB_execute,
    input logic [15:0] rd_execute,
    output logic wre_memory,
    output logic select_writeback_data_mux_memory,
    output logic write_memory_enable_memory,
    output logic [15:0] ALUresult_out,
    output logic [15:0] srcA_memory,
    output logic [15:0] srcB_memory,
    output logic [15:0] rd_memory
);

    // Registros internos
    logic [15:0] ALUresult;
    logic wre;
    logic select_writeback_data_mux;
    logic write_memory_enable;
    logic [15:0] srcA;
    logic [15:0] srcB;
    logic [15:0] rd;

    // Proceso de escritura en el registro
    always_ff @(posedge clk) begin
        if (reset) begin
            ALUresult <= 16'b0;
            wre <= 1'b0;
            select_writeback_data_mux <= 1'b0;
            write_memory_enable <= 1'b0;
            srcA <= 16'b0;
            srcB <= 16'b0;
            rd <= 16'b0;
        end else begin
            ALUresult <= ALUresult_in;
            wre <= wre_execute;
            select_writeback_data_mux <= select_writeback_data_mux_execute;
            write_memory_enable <= write_memory_enable_execute;
            srcA <= srcA_execute;
            srcB <= srcB_execute;
            rd <= rd_execute;
        end
    end

    // Salidas del registro
    assign ALUresult_out = ALUresult;
    assign wre_memory = wre;
    assign select_writeback_data_mux_memory = select_writeback_data_mux;
    assign write_memory_enable_memory = write_memory_enable;
    assign srcA_memory = srcA;
    assign srcB_memory = srcB;
    assign rd_memory = rd;

endmodule
