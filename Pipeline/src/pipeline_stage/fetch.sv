module fetch (
    input   logic   [31:0]instr_d,
    input   logic   [31:0]pc_f,
    input   logic   [31:0]pc_branch_d,
    input   logic   [31:0]reg_src_a_d,
    input   logic   pc_src_d,
    input   logic   [1:0]jump,

    output  logic   [31:0]pc_next_f,
    output  logic   [31:0]pc_plus_4_f
);
    logic [31:0]pc_branch_next;

    adder pcAdd4(
        .a(pc_f),
        .b(4),
        .result(pc_plus_4_f)
    );
    mux2 pcBranchNext(
        .selector(pc_src_d),
        .s0(pc_plus_4_f),
        .s1(pc_branch_d),
        .result(pc_branch_next)
    );

    mux4 pcNext(
        .selector(jump),
        .s0(pc_branch_next), // beq, bne & normal instructor
        .s1({pc_f[31:28], instr_d[25:0], 2'b00}), // jal, j
        .s2(reg_src_a_d),  // jr
        .s3(),
        .result(pc_next_f)
    );

endmodule: fetch