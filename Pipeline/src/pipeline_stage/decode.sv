module decode (
    input   logic   clk,

    input   logic   [31:0]instr_d,
    input   logic   [31:0]pc_plus_4_d,

    input   logic   reg_we_w,
    input   logic   [31:0]alu_result_m,
    input   logic   [4:0]reg_write_addr_w,
    input   logic   [31:0]reg_write_data_w,

    input   logic   forward_a_d,
    input   logic   forward_b_d,

    output  logic   [31:0]reg_data_1_d,
    output  logic   [31:0]reg_data_2_d,
    output  logic   [4:0]rs_d,
    output  logic   [4:0]rt_d,
    output  logic   [4:0]rd_d,
    output  logic   [31:0]imm_d,
    output  logic   [31:0]shamt_d,

    output  logic   [31:0]pc_branch_d,
    output  logic   [31:0]reg_src_a_d,
    output  logic   equal_d
);
    logic [31:0]reg_src_b_d;

    assign rs_d = instr_d[25:21];
    assign rt_d = instr_d[20:16];
    assign rd_d = instr_d[15:11];

    register_file reg_file(
        .clk(clk),
        .we(reg_we_w),
        .r_addr_1(instr_d[25:21]),
        .r_addr_2(instr_d[20:16]),
        .w_addr(reg_write_addr_w),
        .write_data(reg_write_data_w),
        .rd_data_1(reg_data_1_d),
        .rd_data_2(reg_data_2_d)
    );
    mux2 srcAMux2(
        .selector(forward_a_d),
        .s0(reg_data_1_d),
        .s1(alu_result_m),
        .result(reg_src_a_d)
    );
    mux2 srcBMux2(
        .selector(forward_b_d),
        .s0(reg_data_2_d),
        .s1(alu_result_m),
        .result(reg_src_b_d)
    );
    equal_cmp equalCmp(
        .in_1(reg_src_a_d),
        .in_2(reg_src_b_d),
        .out(equal_d)
    );

    sign_extension immExtension(
        .in(instr_d[15:0]),
        .out(imm_d)
    );
    adder getPcBranch(
        .a(pc_plus_4_d),
        .b({imm_d[29:0], 2'b00}),
        .result(pc_branch_d)
    );

    unsign_extension shamtExtension(
        .in(instr_d[10:6]),
        .out(shamt_d)
    );
endmodule: decode