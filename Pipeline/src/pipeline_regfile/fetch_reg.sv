module fetch_reg (
    input   logic   clk, rst,
    input   logic   stall_f,
    input   logic   [31:0]pc_next_f,
    output  logic   [31:0]pc_f
);
    flip_flop pcReg (
        .clk(clk),
        .rst(rst),
        .we(~stall_f),
        .clr(0),
        .in(pc_next_f),
        .out(pc_f)
    );
    
endmodule: fetch_reg