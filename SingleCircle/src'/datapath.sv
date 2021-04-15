module datapath (
    input  logic        clk,
    input  logic        reset,
    input  logic        mem_to_reg_i,
    input  logic        pc_src_i,
    input  logic        reg_dst_i,
    input  logic        reg_write_i,
    input  logic        jump_i,
    input  logic        alu_src_i,
    input  logic [31:0] instr_i,
    input  logic [31:0] readdata_i,
    input  logic [2:0]  alu_control_i,
    output logic        zero,
    output logic [31:0] alu_out,
    output logic [31:0] write_data_o
);
    logic [4:0] write_reg;
    logic [31:0] pc_next, pc_next_br, pc_plus_4, pc_branch,
        sign_imm, sign_immsh, scr_a, scr_b, result;
    
    flip_flop #(32) pc_reg(
        .clk(clk),
        .reset(reset),
        .d_i(pc_next),
        .q_o(pc_o)
    );

    adder pc_adder1(
        .a_i(pc),
        .b_i(32'd4),
        .result_o(pc_plus_4)
    );

    adder pc_adder2(
        .a_i(pc_plus_4),
        .b_i(sign_immsh),
        .result_o(pc_branch)
    );

    mux2 #(32) pcbrmux(
        .data0_i(pc_plus_4),
        .data1_i(pc_branch),
        .select_i(pc_src_i),
        .result_o(pc_next_br)
    );

    mux2 #(32) pcmux(
        .data0_i(pc_next_br),
        .data1_i({pc_plus_4[31:28], instr_i[25:0],
            2'b00}),
        .select_i(jump_i),
        .result_o(pc_next)
    );

    regfile rf(
        .clk(clk),
        .we3(reg_write_i),
        .wa3(write_reg),
        .wd3(result),
        .ra1(instr_i[25:21]),
        .ra2(instr_i[20:16]),
        .rd1(src_a),
        .rd2(write_data_o)
    );

    mux2 #(5) wrmux(
        .data0_i(instr_i[20:16]),
        .data1_i(instr_i[15:11]),
        .select_i(reg_dst_i),
        .result_o(write_reg)
    );

    mux2 #(32) remux(
        .data0_i(alu_out),
        .data1_i(readdata_i),
        .select_i(mem_to_reg_i),
        .result_o(result)
    );

    signext se(
        .a(instr_i[15:0]),
        .y(sign_imm)
    );

    mux2 #(32) srcbmux(
        .data0_i(write_data_o),
        .data1_i(sign_imm),
        .select_i(alu_src_i),
        .result_o(src_b)
    );
    alu alu(
        .a_i(src_a),
        .b_i(src_b),
        .alu_control_i(alu_control_i),
        .result_o(alu_out),
        .zero(zero)
    );
endmodule