module control_unit (
    input   logic   clk, rst,
    input   logic   zero,
    input   logic   [5:0]operation,
    input   logic   [5:0]func,

    output  logic   [1:0]alu_src_a,
    output  logic   [2:0]alu_src_b,
    output  logic   [1:0]pc_src,
    output  logic   instr_or_data,
    output  logic   instr_reg_we,
    output  logic   reg_we,
    output  logic   reg_write_addr,
    output  logic   reg_write_data,
    output  logic   mem_we,
    output  logic   pc_reg_we,
    output  logic   [2:0]alu_controller
);
    logic [2:0]alu_op;
    logic [1:0]branch;
    logic pc_write;

    main_decoder main_dec(
        .clk(clk),
        .rst(rst),
        .operation(operation),
        .func(func),
        .branch(branch),
        .alu_src_a(alu_src_a),
        .alu_src_b(alu_src_b),
        .pc_src(pc_src),
        .instr_or_data(instr_or_data),
        .instr_reg_we(instr_reg_we),
        .pc_write(pc_write),
        .reg_we(reg_we),
        .reg_write_addr(reg_write_addr),
        .reg_write_data(reg_write_data),
        .mem_we(mem_we),
        .alu_op(alu_op)
    );

    alu_decoder alu_decoder(
        .func(func),
        .alu_op(alu_op),
        .alu_control(alu_controller)
    );
    assign pc_reg_we = ((branch[1] & zero) | (branch[0] & !zero)) | pc_write;
endmodule


module main_decoder (
    input   logic   clk, rst,
    input   logic   [5:0]operation,
    input   logic   [5:0]func,

    output  logic   [1:0]branch,
    output  logic   [1:0]alu_src_a,
    output  logic   [2:0]alu_src_b,
    output  logic   [1:0]pc_src,
    output  logic   instr_or_data,
    output  logic   instr_reg_we,
    output  logic   pc_write,
    output  logic   reg_we,
    output  logic   reg_write_addr,
    output  logic   reg_write_data,
    output  logic   mem_we,
    output  logic   [2:0]alu_op
);
    // state
    parameter Fetch         = 5'b0_0000;
    parameter Decode        = 5'b0_0001;
    parameter Jump          = 5'b0_0010;
    parameter LWorSW        = 5'b0_0011;
    parameter LWMEMRead     = 5'b0_0100;
    parameter SWMemWrite    = 5'b0_0101;
    parameter LWRegWrite    = 5'b0_0110;
    parameter Beq           = 5'b0_0111;
    parameter Bne           = 5'b0_1000;
    parameter Addi          = 5'b0_1001;
    parameter Andi          = 5'b0_1010;
    parameter Ori           = 5'b0_1011;
    parameter Jr            = 5'b0_1100;
    parameter ShiftLL       = 5'b0_1101;
    parameter ShiftRL       = 5'b0_1110;
    parameter ShiftRA       = 5'b0_1111;
    parameter RType         = 5'b1_0000;
    parameter AluWriteBack  = 5'b1_0001;


    parameter LW    = 6'b10_0011;
    parameter SW    = 6'b10_1011;
    parameter BEQ   = 6'b00_0100;
    parameter BNE   = 6'b00_0101;
    parameter ADDI  = 6'b00_1000;
    parameter ANDI  = 6'b00_1100;
    parameter ORI   = 6'b00_1101;
    parameter J     = 6'b00_0010;
    parameter RTYPE = 6'b00_0000;

    parameter SLL   = 6'b00_0000;
    parameter SRL   = 6'b00_0010;
    parameter SLA   = 6'b00_0011;
    parameter JR    = 6'b00_1000;

    logic [4:0]stat, nextstat;

    logic [18:0]controls;
    assign {branch, alu_src_a, alu_src_b, pc_src, instr_or_data,
        instr_reg_we, pc_write, reg_write_addr, reg_write_data, mem_we,
        alu_op} = controls;

    always_ff @( posedge clk or posedge rst ) begin
        if(rst)
            stat <= Fetch;
        else
            stat <= nextstat; 
    end

    always_comb begin
        case(stat)
            Fetch:  nextstat = Decode;
            Decode: case(operation)
                LW:     nextstat = LWorSW;
                SW:     nextstat = LWorSW;
                BEN:    nextstat = Beq;
                BNE:    nextstat = Bne;
                ADDI:   nextstat = Addi;
                ANDI:   nextstat = Andi;
                ORI:    nextstat = Ori;
                J:      nextstat = Jump;
                RTYPE:  case(func)
                    JR:     nextstat = Jr;
                    SLL:    nextstat = ShiftLL;
                    SRL:    nextstat = ShiftRL;
                    SRA:    nextstat = ShiftRA;
                    default:nextstat = RType;
                endcase

                default:nextstat = 5'bX_XXXX;
            endcase

            LWorSW: case(operation):
                LW: nextstat = LWMEMRead;
                SW: nextstat = SWMemWrite;
                default:nextstat = 5'bX_XXXX;
            endcase

            LWMEMRead:  nextstat = LWRegWrite;
            Addi:       nextstat = AluWriteBack;
            Andi:       nextstat = AluWriteBack;
            Ori:        nextstat = AluWriteBack;
            ShiftLL:    nextstat = AluWriteBack;
            ShiftRL:    nextstat = AluWriteBack;
            ShiftRA:    nextstat = AluWriteBack;

            Jump:       nextstat = Fetch;
            SWMemWrite: nextstat = Fetch;
            LWRegWrite: nextstat = Fetch;
            Beq:        nextstat = Fetch;
            Bne:        nextstat = Fetch;
            Jr:         nextstat = Fetch;
            AluWriteBack:nextstat = Fetch;
            default:nextstat = 5'bX_XXXX;
        endcase
    end

    always_comb begin
        case(stat)
            Fetch:      19'b0000_0010_0011_0000_000;
            Decode:     19'b0000_0110_0000_0000_000;
            Jr:         19'b0000_0001_1001_0000_000;
            Jump:       19'b0000_0001_0001_0000_000;
            Beq:        19'b1001_0000_1000_0000_000;
            Bne:        19'b0101_0000_1000_0000_000;
            LWorSW:     19'b0001_0100_0000_0000_000;
            LWMemRead:  19'b0000_0000_0100_0000_000;
            SWMemRead:  19'b0000_0000_0100_0001_000;
            LWRegWrite: 19'b0000_0000_0000_1000_000;
            Addi:       19'b0001_0100_0000_0000_000;
            Andi:       19'b0001_0100_0000_0000_010;
            Ori:        19'b0001_0100_0000_0000_011;
            ShiftLL:    19'b0010_1000_0000_0000_100;
            ShiftRL:    19'b0010_1000_0000_0000_101;
            ShiftRA:    19'b0010_1000_0000_0000_110;
            RType:      19'b0001_0000_0000_0000_111;
            AluWriteBack: 19'b0000_0000_0000_1100_000;
            default:    19'bXXXX_XXXX_XXXX_XXXX_XXX;
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