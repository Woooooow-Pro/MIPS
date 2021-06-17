module branch_predict_buffer #(
    parameter INDEX_WIDTH = 10;
)(
    input   logic   clk,
    input   logic   rst,
    input   logic   en,

    input   logic   [31:0]pc_f,
    input   logic   [31:0]instr_f,
    
    input   logic   is_branch_d,
    input   logic   miss,
    input   logic   [31:0]pc_branch_d,

    output  logic   last_taken,
    output  logic   [31:0]predict_pc
);
    logic [31:0]pc_plus_4, pc_next;
    logic is_branch_f, is_jump_f;

    logic [INDEX_WIDTH-1:0]index;
    logic [1:0]state;
    logic taken;

    assign index = pc_f[INDEX_WIDTH+1:2];
    assign takem = last_taken ^ miss;

    pc_decode pcDecode(
        .pc(pc_f),
        .instr(instr_f),
        .pc_plus_4(pc_plus_4),
        .pc_next(pc_next),
        .in_branch(is_branch_f),
        .is_jump(is_jump_f)
    );

    branch_history_table BHT(
        .clk,
        .rst,
        .en,
        .update_en(is_branch_d),
        .last_taken(taken),
        .index(index),
        .state(state)
    );

    assign predict_pc = is_jump_f | (is_branch_f & state[1])? pc_next: pc_plus_4;

    always_ff @( posedge clk ) begin
        if(rst) begin
            last_taken <= '0;
        end
        else if(en) begin
            last_taken <= state[1];
        end
    end
    
endmodule: branch_predict_buffer