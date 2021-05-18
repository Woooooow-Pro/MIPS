`timescale 1ns / 1ps

module testbench(
    );

    logic clk;
    logic  reset;
    logic  [31:0] writedata,dataadr;
    logic  memwrite;

    initial begin
        reset <= 1;
        #22;
        reset <= 0;
    end

    cpu dut(clk,reset,dataadr,writedata, memwrite);

    always begin
        clk <= 1;
        #5;
        clk <= 0;
        #5;
    end
endmodule
