module datapath (
    input   logic   clk, rst,
    input   logic   reg_we,
    input   logic   [1:0]reg_write_addr,
    input   logic   [1:0]reg_write_data,
    input   logic   instr_reg_we,
    input   logic   instr_or_data,
    input   logic   pc_reg_we,
    input   logic   [1:0]alu_src_a,
    input   logic   [2:0]alu_src_b,
    input   logic   [1:0]pc_src,
    input   logic   [2:0]alu_controller,
    input   logic   [31:0]mem_read_data,

    output  logic   zero,
    output  logic   [5:0]operation,
    output  logic   [5:0]func,
    output  logic   [31:0]mem_write_data,
    output  logic   [31:0]mem_data_addr
);

    logic [31:0]pc, pc_next;
    logic [31:0]instr;
    logic [31:0]mem_data2reg_file;
    logic [31:0]reg_file_write_data, reg_file_read1, reg_file_read2, reg_out1, reg_out2;
    logic [31:0] src_a, src_b, alu_result, alu_reg_out;
    logic [31:0] imm, shift_imm;
    logic [4:0]reg_file_write_addr;

    // set operation and func
    assign operation = instr[31:26];
    assign func = instr[5:0];

    // set mem_write_data
    assign mem_write_data = reg_out2;

    // set pc
    flip_flop pcRegister(
        .clk(clk),
        .rst(rst),
        .we(pc_reg_we),
        .in(pc_next),
        .out(pc)
    );

    // mux4 choose pc next
    mux4 pcNext(
        .selector(pc_src),
        .s0(alu_result),
        .s1(alu_reg_out),
        .s2({pc[31:28], instr[25:0], 2'b00}),
        .s3(reg_out1),
        .result(pc_next)
    );

    // mux2 choose mem_data_addr
    mux2 memWriteAddr(
        .selector(instr_or_data),
        .s0(pc),
        .s1(alu_reg_out),
        .result(mem_data_addr)
    );

    // instruct register
    flip_flop instrRegister(
        .clk(clk),
        .rst(rst),
        .we(instr_reg_we),
        .in(mem_read_data),
        .out(instr)
    );

    // memory data register
    flip_flop memDataRegister(
        .clk(clk),
        .rst(rst),
        .we(1),
        .in(mem_read_data),
        .out(mem_data2reg_file)
    );

    // mux4 choose reg_file_write_data
    mux4 regFileWriteDataMux4(
        .selector(reg_write_data),
        .s0(alu_reg_out),
        .s1(mem_data2reg_file),
        .s2(pc),
        .s3(),
        .result(reg_file_write_data)
    );

    // mux4 choose reg file wrtie addr
    mux4 regFileWriteAddrMux4(
        .selector(reg_write_addr),
        .s0(instr[20:16]),
        .s1(instr[15:11]),
        .s2({5'd31}),
        .s3(),
        .result(reg_file_write_addr)
    );

    // register file operation
    register_file regFile(
    .clk(clk),
    .we(reg_we),
    .r_addr_1(instr[25:21]),
    .r_addr_2(instr[20:16]),
    .w_addr(reg_file_write_addr),
    .write_data(reg_file_write_data),
    .rd_data_1(reg_file_read1),
    .rd_data_2(reg_file_read2)
    );

    // register to store the output of register file
    flip_flop regFileSrc1Reg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .in(reg_file_read1),
        .out(reg_out1)
    );

    flip_flop regFileSrc2Reg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .in(reg_file_read2),
        .out(reg_out2)
    );

    // imm operation
    sign_extension getImm(
        .in(instr[15:0]),
        .out(imm)
    );

    unsign_extension getShiftImm(
        .in(instr[10:6]),
        .out(shift_imm)
    );

    // mux4 & mux8 choose alu_src
    mux4 getAluSrcA(
        .selector(alu_src_a),
        .s0(pc),
        .s1(reg_out1),
        .s2(reg_out2),
        .s3(),
        .result(src_a)
    );

    mux8 getAluSrcB(
        .selector(alu_src_b),
        .s0(reg_out2),
        .s1(4),
        .s2(imm),
        .s3({imm[29:0], 2'b00}),
        .s4(shift_imm),
        .s5(),
        .s6(),
        .s7(),
        .result(src_b)
    );

    // alu operation
    alu alu(
        .a_i(src_a),
        .b_i(src_b),
        .alu_control_i(alu_controller),
        .result_o(alu_result),
        .zero(zero)
    );

    flip_flop aluReg(
        .clk(clk),
        .rst(rst),
        .we(1),
        .in(alu_result),
        .out(alu_reg_out)
    );

endmodule