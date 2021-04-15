//`include "control_unit.sv"
//`include "datapath.sv"
module mips (
    input   logic   clk, rst,
    input   logic   [31:0]instr,
    input   logic   [31:0]read_data,
    output  logic   mem_we,
    output  logic   [31:0]pc,
    output  logic   [31:0]alu_result,
    output  logic   [31:0]mem_write_data
);
    logic zero, pc_src, reg_write_addr, 
        reg_write_data, alu_src, reg_we;
    logic [1:0]jump;
    logic [2:0]alu_controller;

    control_unit control_unit(
        .operation(instr[31:26]),
        .func(instr[5:0]),
        .zero(zero),
        .pc_src(pc_src),
        .jump(jump),
        .reg_we(reg_we),
        .reg_write_addr(reg_write_addr),
        .reg_write_data(reg_write_data),
        .alu_src(alu_src),
        .alu_controller(alu_controller),
        .mem_we(mem_we)
    );
    datapath  datapath(
        .clk(clk),
        .rst(rst),
        .pc_src(pc_src),
        .reg_write_data(reg_write_data),
        .reg_write_addr(reg_write_addr),
        .reg_we(reg_we),
        .alu_src(alu_src),
        .jump(jump),
        .alu_controller(alu_controller),
        .instr(instr),
        .read_data(read_data),
        .zero(zero),
        .pc(pc),
        .alu_result(alu_result),
        .mem_write_data(mem_write_data)
);
endmodule