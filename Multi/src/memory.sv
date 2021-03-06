module memory #(
    parameter Size = 256
)(
    input   logic   clk, we,
    input   logic   [31:0]data_addr,
    input   logic   [31:0]write_data,
    output  logic   [31:0]read_data
);
    logic [31:0] RAM [Size - 1:0];

    initial begin
        $readmemh("instr.dat", RAM);
    end

    always_ff @(posedge clk) begin
        if(we)
            RAM[data_addr[31:2]] <= write_data;
    end

    assign read_data = RAM[data_addr[31:2]];
endmodule