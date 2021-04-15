module data_mem #(
    parameter Size = 64;
)(
    input   logic   clk, we,
    input   logic   [31:0]data_addr,
    input   logic   [31:0]write_data,
    output  logic   [31:0]read_data
);
    logic [31:0] RAM [Size - 1:0];

    always_ff @(posedge clk) begin
        if(we)
            RAM[data_addr[31:2]] <= wd;
    end

    assign read_data = RAMRAM[data_addr[31:2]];
endmodule