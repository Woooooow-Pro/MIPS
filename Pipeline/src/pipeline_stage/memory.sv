module memory (
    input   logic   [2:0]control_m_i,

    output  logic   sel_reg_write_data_m,
    output  logic   reg_we_m,
    output  logic   mem_we_m,
    output  logic   [1:0]control_m_o
);
    assign {reg_we_m, sel_reg_write_data_m, mem_we_m} = control_m_i;
    assign control_m_o = {reg_we_m, sel_reg_write_data_m};

endmodule: memory