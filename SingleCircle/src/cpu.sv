`timescale 1ns/ 1ps
//`include "mips.sv"
//`include "instr_mem.sv"
//`include "IO/DataMemoryDecoder.sv"
module cpu (
    input   logic   clk, rst,
    input   logic   buttonL,
    input   logic   buttonR,
    input   logic   [15:0]switch,
    output  logic   [7:0]AN,
    output  logic   DP,
    output  logic   [6:0]A2G
);
    logic [31:0]pc, instr, read_data;
    logic   mem_we;
    logic   [31:0]mem_write_data;
    logic   [31:0]data_addr;

    mips mips(
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .read_data(read_data),
        .mem_we(mem_we),
        .pc(pc),
        .alu_result(data_addr),
        .mem_write_data(mem_write_data)
    );

    DataMemoryDecoder DataMemoryDecoder(
        .clk(clk),
        .write_EN(mem_we),
        .data_addr(data_addr),
        .write_data(mem_write_data),
        .read_data(read_data),
        .rst(rst),
        .buttonL(buttonL),
        .buttonR(buttonR),
        .switch(switch),
        .AN(AN),
        .DP(DP),
        .A2G(A2G)
    );

//    data_mem data_mem(
//        .clk(clk),
//        .we(mem_we),
//        .data_addr(data_addr),
//        .write_data(mem_write_data),
//        .read_data(read_data)
//    );

    instr_mem instr_mem(
        .pc_addr(pc[7:2]),
        .instr(instr)
    );
endmodule