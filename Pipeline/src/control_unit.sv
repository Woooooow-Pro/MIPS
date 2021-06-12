module control_unit (
    input   logic   [5:0]operation,
    input   logic   [5:0]func,
    input   logic   equal,

    output  logic   pc_src,
    output  logic   [1:0]jump,
    output  logic   [1:0]branch,
    // output  logic   sel_jal,
    output  logic   [10:0]control
);
    logic [2:0]alu_op, alu_control;
    logic [1:0]sel_alu_src_b;
    logic reg_we, sel_reg_write_data, mem_we, sel_alu_src_a, sel_reg_write_addr, sel_jal;

    main_decoder main_decoder(
        .operation(operation),
        .func(func),
        .jump(jump),
        .reg_we(reg_we),
        .sel_reg_write_addr(sel_reg_write_addr),
        .sel_reg_write_data(sel_reg_write_data),
        .mem_we(mem_we),
        .sel_alu_src_a(sel_alu_src_a),
        .sel_alu_src_b(sel_alu_src_b),
        .alu_op(alu_op),
        .branch(branch),
        .sel_jal(sel_jal)
    );

    alu_decoder alu_decoder(
        .func(func),
        .alu_op(alu_op),
        .alu_control(alu_controll)
    );
    assign pc_src = (branch[1] & !equal) | (branch[0] & equal);
    assign control = {reg_we, sel_reg_write_data, mem_we, alu_control, sel_alu_src_a,
        sel_alu_src_b, sel_reg_write_addr, sel_jal};
endmodule: control_unit


module main_decoder (
    input   logic   [5:0]operation,
    input   logic   [5:0]func,
    output  logic   [1:0]jump,
    output  logic   reg_we,
    output  logic   sel_reg_write_addr,
    output  logic   sel_reg_write_data,
    output  logic   mem_we,
    output  logic   sel_alu_src_a,
    output  logic   [1:0]sel_alu_src_b,
    output  logic   [2:0]alu_op,
    output  logic   [1:0]branch,
    output  logic   sel_jal
);
    logic [14:0]controls;
    assign {jump, reg_we, sel_reg_write_addr, sel_reg_write_data, mem_we, sel_alu_src_a,
        sel_alu_src_b, alu_op, branch, sel_jal} = controls;
    always_comb begin
        case(operation)
            6'b00_0000: begin
                case (func)
                    6'b00_0000: controls = 15'b00_1_1_0_0_1_10_100_00_0; // sll
                    6'b00_0010: controls = 15'b00_1_1_0_0_1_10_101_00_0; // srl
                    6'b00_0011: controls = 15'b00_1_1_0_0_1_10_110_00_0; // sra
                    6'b00_1000: controls = 15'b10_0_X_0_0_0_00_000_00_0; // jr
                    default:    controls = 15'b00_1_1_0_0_0_00_111_00_0; // R-Type
                endcase
            end
            6'b10_0011: controls = 15'b00_1_0_1_0_0_01_000_00_0; // lw
            6'b10_1011: controls = 15'b00_0_0_0_1_0_01_000_00_0; // sw
            6'b00_0100: controls = 15'b00_0_X_0_0_0_00_000_01_0; // beq
            6'b00_0101: controls = 15'b00_0_X_0_0_0_00_000_10_0; // bne
            6'b00_1000: controls = 15'b00_1_0_0_0_0_01_000_00_0; // addi
            6'b00_1100: controls = 15'b00_1_0_0_0_0_01_010_00_0; // andi
            6'b00_1101: controls = 15'b00_1_0_0_0_0_01_011_00_0; // ori
            6'b00_0010: controls = 15'b01_0_X_0_0_0_00_000_00_0; // j
            6'b00_0010: controls = 15'b01_1_X_0_0_0_00_000_00_1; // jal
            default:    controls = 15'bXXX_XXXX_XXXX_XXXX; // illegal op
        endcase
    end
endmodule: main_decoder


module alu_decoder (
    input   logic   [5:0]func,
    input   logic   [2:0]alu_op,
    output  logic   [2:0]alu_control
);
    always_comb begin
        case(alu_op)
            3'b000: alu_control = 3'b010; // add
            3'b001: alu_control = 3'b110; // sub
            3'b010: alu_control = 3'b000; // and
            3'b011: alu_control = 3'b001; // or
            3'b100: alu_control = 3'b011; // sll
            3'b101: alu_control = 3'b100; // srl
            3'b110: alu_control = 3'b101; // sra
            default: case(func)
                6'b10_0100: alu_control = 3'b000; // and
                6'b10_0101: alu_control = 3'b001; // or
                6'b10_0000: alu_control = 3'b010; // add
                6'b00_0100: alu_control = 3'b011; // sllv
                6'b00_0110: alu_control = 3'b100; // srlv
                6'b00_0111: alu_control = 3'b101; // srav
                6'b10_0010: alu_control = 3'b110; // sub
                6'b10_1010: alu_control = 3'b111; // slt
                default:    alu_control = 3'bXXX; // illegal funct
            endcase
        endcase
    end
endmodule: alu_decoder