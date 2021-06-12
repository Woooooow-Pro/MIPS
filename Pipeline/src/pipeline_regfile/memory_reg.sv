module memory_reg (
    input   logic   clk, rst,
    
    input   logic   [2:0]control_e,
    input   logic   [31:0]alu_result_e,
    input   logic   [31:0]mem_write_data_e,
    input   logic   [4:0]reg_write_addr_e,

    output  logic   [2:0]control_m,
    output  logic   [31:0]alu_result_m,
    output  logic   [31:0]mem_write_data_m,
    output  logic   [4:0]reg_write_addr_m
);
    flip_flop#(3) controlReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(0),
        .in(control_e),
        .out(control_m)
    );

    flip_flop aluResultReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(0),
        .in(alu_result_e),
        .out(alu_result_m)
    );
    flip_flop memWriteDataReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(0),
        .in(mem_write_data_e),
        .out(mem_write_data_m)
    );
    flip_flop#(5) regWriteAddrReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .clr(0),
        .in(reg_write_addr_e),
        .out(reg_write_addr_m)
    );

endmodule: memory_reg