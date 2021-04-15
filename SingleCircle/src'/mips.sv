module mips (
    input  logic             clk,
    input  logic             reset,
    input  logic      [31:0] instr,
    input  logic      [31:0] readdata,
    output logic             memwrite,
    output logic      [31:0] aluout,
    input  logic      [31:0] writedata,
    input  logic      [31:0] pc
);
    logic   mem_to_reg, zero, branch, pc_src,
        reg_dst, reg_write, jump, alu_src;
    logic [2:0] alu_control;
    control_unit control_unit(
        .op_i(instr[31:26]),
        .funct_i(instr[5:0]),
        .zero_i(zero),
        .mem_to_reg_o(mem_to_reg),
        .mem_write_o(memwrite),
        .pc_src_o(pc_src),
        .alu_src_o(alu_src),
        .reg_dst_o(reg_dst),
        .reg_write_o(reg_write),
        .jump_o(jump),
        .alu_control_o(alu_control)
    );

    datapath dp(
        .clk(clk),
        .reset(reset),
        .mem_to_reg_i(mem_toreg),
        .pc_src_i(pc_src),
        .reg_dst_i(reg_dst),
        .reg_write_i(reg_write),
        .jump_i(jump),
        .alu_src_i(alu_src),
        .instr_i(instr),
        .readdata_i(readdata),
        .alu_control_i(alu_control),
        .zero(zero),
        .alu_out(aluout),
        .write_data_o(writedata)
    );
endmodule