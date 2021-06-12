module writeback_reg (
    input   logic   clk, rst,
    
    input   logic   [1:0]control_m,
    input   logic   [31:0]mem_read_data_m,
    input   logic   [31:0]alu_result_m,
    input   logic   [4:0]reg_write_addr_m,

    output  logic   [1:0]control_w,
    output  logic   [31:0]mem_read_data_w,
    output  logic   [31:0]alu_result_w,
    output  logic   [4:0]reg_write_addr_w
);
    flip_flop#(2) controlReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(0),
        .in(control_m),
        .out(control_w)
    );

    flip_flop memReadDataReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(0),
        .in(mem_read_data_m),
        .out(mem_read_data_w)
    );
    flip_flop aluResultReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(0),
        .in(alu_result_m),
        .out(alu_result_w)
    );
    flip_flop#(5) regWriteAddrReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(0),
        .in(reg_write_addr_m),
        .out(reg_write_addr_w)
    );
endmodule: writeback_reg