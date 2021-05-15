module mips (
    input   logic   clk, rst,
    input   logic   [31:0]mem_read_data,
    output  logic   mem_we,
    output  logic   [31:0]mem_write_data,
    output  logic   [31:0]mem_write_addr
);
    logic zero, instr_or_data, instr_reg_we, reg_we, reg_write_addr
        reg_write_data, mem_we, pc_reg_we;
    logic [1:0]alu_src_a, pc_src;
    logic [2:0]alu_src_b
    logic [2:0]alu_controller;
    logic [5:0]operation, func;

    control_unit control_unit(
        .clk(clk),
        .rst(rst),
        .zero(zero),
        .operation(operation),
        .func(func),

        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .pc_src(pc_src),
        .instr_or_data(instr_or_data),
        .instr_reg_we(instr_reg_we),
        .reg_we(reg_we),
        .reg_write_addr(reg_write_addr),
        .reg_write_data(reg_write_data),
        .mem_we(mem_we),
        .pc_reg_we(pc_reg_we),
        .alu_controller(alu_controller)
    );
    datapath  datapath (
        .clk(clk),
        .rst(rst),
        .reg_we(reg_we),
        .reg_write_addr(reg_write_addr),
        .reg_write_data(reg_write_data),
        .instr_reg_we(instr_reg_we),
        .instr_or_data(instr_or_data),
        .pc_reg_we(pc_reg_we),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .pc_src(pc_src),
        .alu_controller(alu_controller),
        .mem_read_data(mem_read_data),

        .zero(zero),
        .operation(operation),
        .func(func),
        .mem_write_data(mem_write_data),
        .mem_write_addr(mem_write_addr),
    );
endmodule