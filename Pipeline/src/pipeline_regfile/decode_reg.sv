module decode_reg (
    input   logic   clk, rst,
    input   logic   stall_d,
    input   logic   flush_d,
    input   logic   [31:0]instr_f,
    input   logic   [31:0]pc_plus_4_f,

    output  logic   [31:0]instr_d,
    output  logic   [31:0]pc_plus_4_d,
);
    flip_flop instrReg(
        .clk(clk),
        .rst(rst),
        .we(~stall_d),
        .clr(~stall_d & flush_d),
        .in(instr_f),
        .out(instr_d)
    );
    flip_flop pcPlus4Reg(
        .clk(clk),
        .rst(rst),
        .we(~stall_d),
        .clr(0),
        .in(pc_plus_4_f),
        .out(pc_plus_4_d)
    );
endmodule: decode_reg