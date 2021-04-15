//`include "alu.sv"
//`include "register_file.sv"
//`include "utility.sv"
module datapath (
    input   logic   clk, rst,
    input   logic   pc_src,
    input   logic   reg_write_data,
    input   logic   reg_write_addr,
    input   logic   reg_we,
    input   logic   alu_src,
    input   logic   [1:0]jump,
    input   logic   [2:0]alu_controller,
    input   logic   [31:0]instr,
    input   logic   [31:0]read_data,
    output  logic   zero,
    output  logic   [31:0]pc,
    output  logic   [31:0]alu_result,
    output  logic   [31:0]mem_write_data
);
    logic [31:0] pc_next, pc_branch_next, pc_plus_4, pc_branch;
    logic [4:0]  write_reg;
    logic [31:0] write_reg_data;
    logic [31:0] sign_imm, sign_imm_ls;
    logic [31:0] src_a, src_b;

    // next pc logic
    flip_flop pc_reg(
        .clk(clk),
        .rst(rst),
        .in(pc_next),
        .out(pc)
    );
    adder     pcAdd4(
        .a(pc),
        .b(4),
        .result(pc_plus_4)
    );
    sign_extension se(
        .in(instr[15:0]),
        .out(sign_imm)
    );
    lshift2   immLeftShift2(
        .in(sign_imm),
        .out(sign_imm_ls)
    );
    adder     pcBranch(
        .a(sign_imm_ls),
        .b(pc_plus_4),
        .result(pc_branch)
    );
    mux2      pcBranchNext(
        .selector(pc_src),
        .s0(pc_plus_4),
        .s1(pc_branch),
        .result(pc_branch_next)
    );
    mux4      pcNext(
        .selector(jump),
        .s0(pc_branch_next),
        .s1({pc[31:28], instr[25:0], 2'b00}),
        .s2(src_a),
        .s3(),
        .result(pc_next)
    );

    // register file logic
    register_file regFile(
        .clk(clk),
        .we(reg_we),
        .r_addr_1(instr[25:21]),
        .r_addr_2(instr[20:16]),
        .w_addr(write_reg),
        .write_data(write_reg_data),
        .rd_data_1(src_a),
        .rd_data_2(mem_write_data)
    );
    mux2 #(5)     writeReg(
        .selector(reg_write_addr),
        .s0(instr[20:16]),
        .s1(instr[15:11]),
        .result(write_reg)
    );
    mux2          regWriteData(
        .selector(reg_write_data),
        .s0(alu_result),
        .s1(read_data),
        .result(write_reg_data)
    );

    // ALU logic
    mux2 srcB(
        .selector(alu_src),
        .s0(mem_write_data),
        .s1(sign_imm),
        .result(src_b)
    );
    alu  alu(
        .a_i(src_a),
        .b_i(src_b),
        .alu_control_i(alu_controller),
        .result_o(alu_result),
        .zero(zero)
    );
endmodule