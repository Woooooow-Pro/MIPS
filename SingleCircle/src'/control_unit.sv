module control_unit (
    input  logic       [5:0] op_i,
    input  logic       [5:0] funct_i,
    input  logic             zero_i,
    output logic             mem_to_reg_o,
    output logic             mem_write_o,
    output logic             pc_src_o,
    output logic             alu_src_o,
    output logic             reg_dst_o,
    output logic             reg_write_o,
    output logic             jump_o,
    output logic       [2:0] alu_control_o
);
    logic [1:0] alu_op;
    logic       branch;
    main_dec md(
        .op_i(op_i),
        .mem_to_reg_o(mem_to_reg_o),
        .mem_write_o(mem_write_o),
        .branch_o(branch),
        .alu_src_o(alu_src_o),
        .reg_dst_o(reg_dst_o),
        .reg_write_o(reg_write_o),
        .alu_op_o(alu_op)
    );

    alu_dec ad(
        .funct_i(funct_i),
        .alu_op_i(alu_op),
        .alu_control_o(alu_control_o)
    );
    assign pc_src_o = branch & zero;
endmodule




module main_dec (
    input  logic [5:0]  op_i,
    output logic        mem_to_reg_o,
    output logic        mem_write_o,
    output logic        branch_o,
    output logic        alu_src_o,
    output logic        reg_dst_o,
    output logic        reg_write_o,
    output logic [1:0]  alu_op_o
);
    logic [7:0] controls;
    assign {reg_write_o, reg_dst_o, alu_src_o, branch_o,
        mem_write_o, mem_to_reg_o, alu_op_o} = controls;
    always_comb begin
        case(op_i)
            6'b00_0000: controls = 8'b1100_0010;
            6'b10_0011: controls = 8'b1010_0100;
            6'b10_1011: controls = 8'b0010_1000;
            6'b00_0100: controls = 8'b0001_0001;
            default:    controls = 8'bxxxx_xxxx;
        endcase
    end
endmodule




module alu_dec (
    input  logic  [5:0] funct_i,
    input  logic  [1:0] alu_op_i,
    output logic  [2:0] alu_control_o
);
    always_comb begin
        case
            2'b00: alu_control_o = 3'b010; // ADD
            2'b01: alu_control_o = 3'b110; // SUB
            default: case(funct_i)
                6'b10_0000: alu_control_o = 3'b010; // ADD
                6'b10_0010: alu_control_o = 3'b110; // SUB
                6'b10_1000: alu_control_o = 3'b000; // AND
                6'b10_0101: alu_control_o = 3'b001; // OR
                6'b10_1010: alu_control_o = 3'b111; // SLT
                default:    alu_control_o = 3'bxxx;
            endcase
        endcase
    end
endmodule