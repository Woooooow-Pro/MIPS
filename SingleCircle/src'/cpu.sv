module cpu (
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] writedata,
    output logic [31:0] dataadr,
    output logic        memwrite
);
    logic [31:0] pc, instr, readdata;
    imem imem(
        .pc_addr(pc[7:2]),
        .instr_data(instr)
    );

    mips mips(
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .readdata(readdata),
        .memwrite(memwrite),
        .aluout(dataadr),
        .writedata(writedata),
        .pc(pc)
    );

    dmem dmem(
        .clk(clk),
        .we(memwrite),
        .a(dataadr),
        .wd(writedata),
        .rd(readdata)
    );
endmodule