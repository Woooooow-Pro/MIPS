`timescale 1ns / 1ps

module testbench(
    );

    logic clk;
    logic  reset;
    // logic  L,R;
    // logic [15:0]SW;
    // logic [7:0]AN;
    // logic DP;
    // logic [6:0]A2G;
    logic  [31:0] writedata,dataadr;
    logic  memwrite;
    // cpu dut(clk,reset,L,R,SW,AN,DP,A2G);
    // initial
    //     begin
    //         SW <= 16'h1234;
    //         reset <=1;
    //         #50;
    //         reset <=0;
    //         #50;
    //         R <= 1;
    //         #50;
    //         R <= 0;
    //         #200;
    //         L <= 1;
    //         #50;
    //         L <= 0;

    //     end

    initial begin
        reset <= 1;
        #22;
        reset <= 0;
    end
    cpu dut(clk,reset,dataadr,writedata, memwrite);
        
    // always@ (negedge clk) begin
    //     if(memwrite) begin
    //         if(dataadr===84&writedata===7) begin
    //             $display("Simulation succeed");
    //             $stop;
    //         end
    //         else if(dataadr!=80) begin
    //             $display("Simulation failed");
    //             $stop;
    //         end
    //     end
    // end

    always begin
        clk <= 1;
        #1;
        clk <= 0;
        #1;
    end
endmodule
