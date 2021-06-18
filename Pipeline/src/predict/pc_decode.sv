module pc_decode (
    input   logic   [31:0]pc,
    input   logic   [31:0]instr,

    output  logic   [31:0]pc_plus_4,
    output  logic   [31:0]pc_next,
    output  logic   is_branch,
    output  logic   is_jump
);

    logic [5:0]op, func;
    logic [31:0]pc_jump, pc_branch;
    logic [31:0]imm;

    assign op = instr[31:26];
    assign func = instr[5:0];

    assign pc_plus_4 = pc + 'd4;
    assign pc_jump = {pc_plus_4[31:28], instr[25:0], 2'b00};
    assign pc_branch = pc_plus_4 + (imm << 2);

    sign_extension signExtension(
        .in(instr[15:0]),
        .out(imm)
    );

    always_comb begin
        case(op)
            6'b000010, 6'b000011: begin     // jal, j
                pc_next = pc_jump;
                is_branch = 0;
                is_jump = 1;
            end
            6'b000100, 6'b000101: begin     // beq, bne
                pc_next = pc_branch;
                is_branch = 1;
                is_jump = 0;
            end
            default: begin                  // others
                pc_next = pc_plus_4;
                is_branch = 0;
                is_jump = 0;
            end
        endcase
    end

endmodule: pc_decode