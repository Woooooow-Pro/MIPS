module execute_reg (
    input   logic   clk, rst,
    input   logic   flush_e,

    input   logic   [10:0]control_d,
    input   logic   [31:0]reg_data_1_d,
    input   logic   [31:0]reg_data_2_d,
    input   logic   [4:0]rs_d,
    input   logic   [4:0]rt_d,
    input   logic   [4:0]rd_d,
    input   logic   [31:0]imm_d,
    input   logic   [31:0]shamt_d,
    input   logic   [31:0]pc_plus_4_d,

    output  logic   [10:0]control_e,
    output  logic   [31:0]reg_data_1_e,
    output  logic   [31:0]reg_data_2_e,
    output  logic   [4:0]rs_e,
    output  logic   [4:0]rt_e,
    output  logic   [4:0]rd_e,
    output  logic   [31:0]imm_e,
    output  logic   [31:0]shamt_e,
    output  logic   [31:0]pc_plus_4_e
);
    flip_flop#(11) controlReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(flush_e),
        .in(control_d),
        .out(control_e)
    );

    flip_flop regData1Reg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(flush_e),
        .in(reg_data_1_d),
        .out(reg_data_1_e)
    );
    flip_flop regData2Reg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(flush_e),
        .in(reg_data_2_d),
        .out(reg_data_2_e)
    );

    flip_flop#(5) rsReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(flush_e),
        .in(rs_d),
        .out(rs_e)
    );
    flip_flop#(5) rtReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(flush_e),
        .in(rt_d),
        .out(rt_e)
    );
    flip_flop#(5) rdReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(flush_e),
        .in(rd_d),
        .out(rd_e)
    );

    flip_flop immReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(flush_e),
        .in(imm_d),
        .out(imm_e)
    );
    flip_flop shamtReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(flush_e),
        .in(shamt_d),
        .out(shamt_e)
    );
    flip_flop pcPlus4Reg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(flush_e),
        .in(pc_plus_4_d),
        .out(pc_plus_4_e)
    );

endmodule: execute_reg