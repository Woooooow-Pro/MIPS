module execute (
    input   logic   [10:0]control_e_i,
    input   logic   [31:0]reg_data_1_e,
    input   logic   [31:0]reg_data_2_e,
    // input   logic   [4:0]rs_e,
    input   logic   [4:0]rt_e,
    input   logic   [4:0]rd_e,
    input   logic   [31:0]imm_e,
    input   logic   [31:0]shamt_e,
    input   logic   [31:0]pc_plus_4_e,

    input   logic   [31:0]reg_write_data_w,
    input   logic   [31:0]alu_result_m,
    
    input   logic   [1:0]forward_a_e,
    input   logic   [1:0]forward_b_e,
    // input   logic   jal_e,

    output  logic   reg_we_e,
    output  logic   sel_reg_write_data_e,
    output  logic   [2:0]control_e_o,
    output  logic   [31:0]alu_result_e,
    output  logic   [31:0]mem_write_data_e,
    output  logic   [4:0]reg_write_addr_e
);
    logic mem_we_e, sel_alu_src_a_e, sel_reg_write_addr_e, sel_jal_e;
    logic [1:0]sel_alu_src_b_e;
    logic [2:0]alu_control_e;
    logic [31:0]read_data_1, read_data_2, alu_src_a, alu_src_b, alu_result_temp;

    assign {reg_we_e, sel_reg_write_data_e, mem_we_e, alu_control_e, sel_alu_src_a_e,
        sel_alu_src_b_e, sel_reg_write_addr_e, sel_jal_e} = control_e_i;
    assign control_e_o = {reg_we_e, sel_reg_write_data_e, mem_we_e};
    assign mem_write_data_e = read_data_2;

    // ALU logic
    mux4 readData1Mux4(
        .selector(forward_a_e),
        .s0(reg_data_1_e),
        .s1(reg_write_data_w),
        .s2(alu_result_m),
        .s3(),
        .result(read_data_1)
    );
    mux4 readData2Mux4(
        .selector(forward_b_e),
        .s0(reg_data_2_e),
        .s1(reg_write_data_w),
        .s2(alu_result_m),
        .s3(),
        .result(read_data_2)
    );
    mux2 aluSrcAMux2(
        .selector(sel_alu_src_a_e),
        .s0(read_data_1),
        .s1(read_data_2),
        .result(alu_src_a)
    );
    mux4 aluSrcBMux4(
        .selector(sel_alu_src_b_e),
        .s0(read_data_2),
        .s1(imm_e),
        .s2(shamt_e),
        .s3(),
        .result(alu_src_b)
    );
    alu aluResult(
        .a_i(alu_src_a),
        .b_i(alu_src_b),
        .alu_control_i(alu_control_e),
        .result_o(alu_result_temp)
    );

    mux4#(5) regWriteAddr(
        .selector({sel_jal_e, sel_reg_write_addr_e}),
        .s0(rt_e),
        .s1(rd_e),
        .s2(5'b11111),
        .s3(),
        .result(reg_write_addr_e)
    );
    mux2 aluResultE(
        .selector(sel_jal_e),
        .s0(alu_result_temp),
        .s1(pc_plus_4_e),
        .result(alu_result_e)
    );

endmodule: execute