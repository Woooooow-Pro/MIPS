module instr_mem #(
    parameter Width = 6,
    parameter Size = 64
)(
    input   logic   [Width - 1:0]   pc_addr,
    output  logic   [31:0]          instr
);
    logic [31:0] RAM [Size - 1:0];

    initial begin
        $readmemh("memfile.data", RAM);
    end

    assign instr = RAM[pc_addr];
endmodule