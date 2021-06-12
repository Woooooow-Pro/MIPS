module memory (
    input   logic   clk,
    input   logic   [2:0]control_m_i,
    input   logic   [31:0]alu_result_m,
    input   logic   [31:0]mem_write_data_m,

    output  logic   sel_reg_write_data_m,
    output  logic   reg_we_m,
    output  logic   [1:0]control_m_o,
    output  logic   [31:0]mem_read_data_m
);
    logic mem_we_m;
    assign {reg_we_m, sel_reg_write_data_m, mem_we_m} = control_m_i;
    assign control_m_o = {reg_we_m, sel_reg_write_data_m};

    data_mem dataMemory(
        .clk,
        .we(mem_we_m),
        .data_addr(alu_result_m),
        .write_data(mem_write_data_m),
        .read_data(mem_read_data_m)
    );
endmodule: memory