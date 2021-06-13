`timescale 1ns / 1ps

module testbench(
    );

    logic clk;
    logic  reset;

    initial begin
        reset <= 1;
        #22;
        reset <= 0;
    end

    cpu dut(clk,reset);

    always begin
        clk <= 1;
        #5;
        clk <= 0;
        #5;
    end
endmodule
