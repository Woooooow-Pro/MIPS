`timescale 1ns/1ps
module cpu (
    input   logic   clk, rst,

    output   logic   [31:0]mem_data_addr,
    output   logic   [31:0]mem_write_data,
    output   logic   mem_we

);

    logic [31:0]mem_read_data;

    mips mips (
        .clk(clk),
        .rst(rst),
        .mem_read_data,
        .mem_we(mem_we),
        .mem_write_data(mem_write_data),
        .mem_data_addr(mem_data_addr)
);

   memory memory(
       .clk(clk),
       .we(mem_we),
       .data_addr(mem_data_addr),
       .write_data(mem_write_data),
       .read_data(mem_read_data)
   );
endmodule