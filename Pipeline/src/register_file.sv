module register_file (
    input   logic   clk, we,
    input   logic   [4:0]r_addr_1,
    input   logic   [4:0]r_addr_2,
    input   logic   [4:0]w_addr,
    input   logic   [31:0]write_data,
    output  logic   [31:0]rd_data_1,
    output  logic   [31:0]rd_data_2
);
    logic [31:0] RegFile[31:0];

    always_ff @(negedge clk) begin
        if(we)
            RegFile[w_addr] <= write_data;
    end

    assign rd_data_1 = r_addr_1? RegFile[r_addr_1]: 0;
    assign rd_data_2 = r_addr_2? RegFile[r_addr_2]: 0;

endmodule: register_file