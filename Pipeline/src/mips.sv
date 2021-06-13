module mips (
    input   logic   clk,
    input   logic   rst,
    input   logic   [31:0]instr,
    input   logic   [31:0]mem_read_data,

    output  logic   [31:0]pc,
    output  logic   mem_we,
    output  logic   [31:0]mem_data_addr,
    output  logic   [31:0]mem_write_data
);
    logic stall_f, stall_d, flush_d, forward_a_d, forward_b_d, flush_e;
    logic [1:0]forward_a_e, forward_b_e;

    logic pc_src_d, equal, reg_we_e, sel_reg_write_data_e,
        reg_we_m, sel_reg_write_data_m, reg_we_w;
    logic [1:0]jump, branch, control_m_o, control_w;
    logic [2:0]control_e_o, control_m;
    logic [10:0]control_d, control_e;

    logic [4:0]rs_d, rt_d, rd_d, rs_e, rt_e, rd_e,
        reg_write_addr_e, reg_write_addr_m, reg_write_addr_w;
    logic [31:0]instr_f, pc_f, pc_next_f, pc_plus_4_f;
    logic [31:0]instr_d, pc_branch_d, reg_src_a_d, pc_plus_4_d, reg_data_1_d, 
        reg_data_2_d, imm_d, shamt_d;
    logic [31:0]reg_data_1_e, reg_data_2_e, imm_e, shamt_e, pc_plus_4_e,
        alu_result_e, mem_write_data_e;
    logic [31:0]alu_result_m, mem_write_data_m, mem_read_data_m;
    logic [31:0]mem_read_data_w, reg_write_data_w, alu_result_w;

    assign pc = pc_f;
    assign instr_f = instr;

    assign mem_data_addr = alu_result_m;
    assign mem_write_data = mem_write_data_m;
    assign mem_read_data_m = mem_read_data;


    fetch_reg fetchReg(
        .clk,
        .rst,
        .stall_f(stall_f),
        .pc_next_f(pc_next_f),
        .pc_f(pc_f)
    );
    fetch fetch(
        .instr_d(instr_d),
        .pc_f(pc_f),
        .pc_branch_d(pc_branch_d),
        .reg_src_a_d(reg_src_a_d),
        .pc_src_d(pc_src_d),
        .jump(jump),
        .pc_next_f(pc_next_f),
        .pc_plus_4_f(pc_plus_4_f)
    );
    decode_reg decodeReg(
        .clk,
        .rst,
        .stall_d(stall_d),
        .flush_d(flush_d),
        .instr_f(instr_f),
        .pc_plus_4_f(pc_plus_4_f),
        .instr_d(instr_d),
        .pc_plus_4_d(pc_plus_4_d)
    );

    // control logic
    control_unit controlUnit(
        .operation(instr_d[31:26]),
        .func(instr_d[5:0]),
        .equal(equal),
        .pc_src(pc_src_d),
        .jump(jump),
        .branch(branch),
        .control(control_d)
    );

    decode decode(
        .clk,
        .instr_d(instr_d),
        .pc_plus_4_d(pc_plus_4_d),
        .reg_we_w(reg_we_w),
        .alu_result_m(alu_result_m),
        .reg_write_addr_w(reg_write_addr_w),
        .reg_write_data_w(reg_write_data_w),
        .forward_a_d(forward_a_d),
        .forward_b_d(forward_b_d),
        .reg_data_1_d(reg_data_1_d),
        .reg_data_2_d(reg_data_2_d),
        .rs_d(rs_d),
        .rt_d(rt_d),
        .rd_d(rd_d),
        .imm_d(imm_d),
        .shamt_d(shamt_d),
        .pc_branch_d(pc_branch_d),
        .reg_src_a_d(reg_src_a_d),
        .equal_d(equal)
    );
    execute_reg executeReg(
        .clk,
        .rst,
        .flush_e(flush_e),
        .control_d(control_d),
        .reg_data_1_d(reg_data_1_d),
        .reg_data_2_d(reg_data_2_d),
        .rs_d(rs_d),
        .rt_d(rt_d),
        .rd_d(rd_d),
        .imm_d(imm_d),
        .shamt_d(shamt_d),
        .pc_plus_4_d(pc_plus_4_d),
        .control_e(control_e),
        .reg_data_1_e(reg_data_1_e),
        .reg_data_2_e(reg_data_2_e),
        .rs_e(rs_e),
        .rt_e(rt_e),
        .rd_e(rd_e),
        .imm_e(imm_e),
        .shamt_e(shamt_e),
        .pc_plus_4_e(pc_plus_4_e)
    );
    execute execute(
        .control_e_i(control_e),
        .reg_data_1_e(reg_data_1_e),
        .reg_data_2_e(reg_data_2_e),
        .rt_e(rt_e),
        .rd_e(rd_e),
        .imm_e(imm_e),
        .shamt_e(shamt_e),
        .pc_plus_4_e(pc_plus_4_e),
        .reg_write_data_w(reg_write_data_w),
        .alu_result_m(alu_result_m),
        .forward_a_e(forward_a_e),
        .forward_b_e(forward_b_e),
        .reg_we_e(reg_we_e),
        .sel_reg_write_data_e(sel_reg_write_data_e),
        .control_e_o(control_e_o),
        .alu_result_e(alu_result_e),
        .mem_write_data_e(mem_write_data_e),
        .reg_write_addr_e(reg_write_addr_e)
    );
    memory_reg memoryReg(
        .clk,
        .rst,
        .control_e(control_e_o),
        .alu_result_e(alu_result_e),
        .mem_write_data_e(mem_write_data_e),
        .reg_write_addr_e(reg_write_addr_e),
        .control_m(control_m),
        .alu_result_m(alu_result_m),
        .mem_write_data_m(mem_write_data_m),
        .reg_write_addr_m(reg_write_addr_m)
    );
    memory memory(
        .control_m_i(control_m),
        .sel_reg_write_data_m(sel_reg_write_data_m),
        .reg_we_m(reg_we_m),
        .mem_we_m(mem_we),
        .control_m_o(control_m_o)
    );
    writeback_reg writebackReg(
        .clk,
        .rst,
        .control_m(control_m_o),
        .mem_read_data_m(mem_read_data_m),
        .alu_result_m(alu_result_m),
        .reg_write_addr_m(reg_write_addr_m),
        .control_w(control_w),
        .mem_read_data_w(mem_read_data_w),
        .alu_result_w(alu_result_w),
        .reg_write_addr_w(reg_write_addr_w)
    );
    writeback writeback(
        .control_w(control_w),
        .mem_read_data_w(mem_read_data_w),
        .alu_result_w(alu_result_w),
        .reg_we_w(reg_we_w),
        .reg_write_data_w(reg_write_data_w)
    );

    hazard_unit hazardUnit(
        .rs_d(rs_d),
        .rt_d(rt_d),
        .branch_d(branch),
        .pc_src_d(pc_src_d),
        .jump_d(jump),
        .rs_e(rs_e),
        .rt_e(rt_e),
        .reg_write_addr_e(reg_write_addr_e),
        .sel_reg_write_data_e(sel_reg_write_data_e),
        .reg_we_e(reg_we_e),
        .reg_write_addr_m(reg_write_addr_m),
        .sel_reg_write_data_m(sel_reg_write_data_m),
        .reg_we_m(reg_we_m),
        .reg_write_addr_w(reg_write_addr_w),
        .reg_we_w(reg_we_w),
        .stall_f(stall_f),
        .stall_d(stall_d),
        .flush_d(flush_d),
        .forward_a_d(forward_a_d),
        .forward_b_d(forward_b_d),
        .flush_e(flush_e),
        .forward_a_e(forward_a_e),
        .forward_b_e(forward_b_e)
    );
endmodule: mips