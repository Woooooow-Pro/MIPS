module control_unit (
    input   logic   [5:0]operation,
    input   logic   [5:0]func,
    input   logic   zero,
    output  logic   pc_src,
    output  logic   [1:0]jump,
    output  logic   reg_we,
    output  logic   reg_write_addr,
    output  logic   reg_write_data,
    output  logic   alu_src_a,
    output  logic   alu_src_b,
    output  logic   [2:0]alu_controller,
    output  logic   mem_we
);
    logic [2:0]alu_op;
    logic [1:0]branch;

    main_decoder main_dec(
        .operation(operation),
        .func(func),
        .branch(branch),
        .jump(jump),
        .reg_we(reg_we),
        .reg_write_addr(reg_write_addr),
        .reg_write_data(reg_write_data),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .mem_we(mem_we),
        .alu_op(alu_op)
    );

    alu_decoder alu_decoder(
        .func(func),
        .alu_op(alu_op),
        .alu_control(alu_controller)
    );
    assign pc_src = (branch[1] & zero) | (branch[0] & !zero);
endmodule


module main_decoder (
    input   logic   [5:0]operation,
    input   logic   [5:0]func,
    output  logic   [1:0]branch,
    output  logic   [1:0]jump,
    output  logic   reg_we,
    output  logic   reg_write_addr,
    output  logic   reg_write_data,
    output  logic   alu_src_a,
    output  logic   alu_src_b,
    output  logic   mem_we,
    output  logic   [2:0]alu_op
);
    logic [12:0]controls;
    assign {branch, jump, reg_we, reg_write_addr,
        reg_write_data, alu_src_b, mem_we, alu_op, alu_src_a} = controls;
    always_comb begin
        case(operation)
            6'b00_0000: begin
                case (func)
                    6'b00_0000: controls = 13'b0000_1001_0100_1; // sll
                    6'b00_0010: controls = 13'b0000_1001_0101_1; // srl
                    6'b00_0011: controls = 13'b0000_1001_0110_1; // sra
                    6'b00_1000: controls = 13'bXX10_0XXX_0XXX_0; // jr
                    default:    controls = 13'b0000_1100_0111_0;
                endcase
            end
            6'b10_0011: controls = 13'b0000_1011_0000_0; // lw
            6'b10_1011: controls = 13'b0000_0XX1_1000_0; // sw
            6'b00_0100: controls = 13'b1000_0XX0_0001_0; // beq
            6'b00_0101: controls = 13'b0100_0XX0_0001_0; // bnq
            6'b00_1000: controls = 13'b0000_1001_0000_0; // addi
            6'b00_1100: controls = 13'b0000_1001_0010_0; // andi
            6'b00_1101: controls = 13'b0000_1001_0011_0; // ori
            6'b00_0010: controls = 13'bXX01_0XXX_0XXX_0; // j
            default:    controls = 13'bXXXX_XXXX_XXXX_0; // illegal op
        endcase
    end
endmodule


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
endmodule