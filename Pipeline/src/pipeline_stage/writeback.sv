module writeback (
    input   logic   [1:0]control_w,
    input   logic   [31:0]mem_read_data_w,
    input   logic   [31:0]alu_result_w,

    output  logic   reg_we_w,
    output  logic   [31:0]reg_write_data_w
);
    logic sel_reg_write_data_w;
    assign {reg_we_w, sel_reg_write_data_w} = control_w;

    mux2 regWriteData(
        .selector(sel_reg_write_data_w),
        .s0(alu_result_w),
        .s1(mem_read_data_w),
        .result(reg_write_data_w)
    );
endmodule: writeback