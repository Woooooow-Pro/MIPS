// MIPS instruction memory
module imem #(
    parameter Width = 32;
    parameter Size = 64;
) (
    input   logic [5:0]         pc_addr,    // PC address 
    output  logic [Width-1:0]  instr_data  // instruction
);
    logic [Width-1:0] RAM [Size:0];

    initial begin
        $readmemh("memfile.data", RAM);
    end

    assign instr_data = RAM[pc_addr];
endmodule