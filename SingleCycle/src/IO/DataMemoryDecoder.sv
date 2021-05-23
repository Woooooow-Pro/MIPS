//`include "utility.sv"
//`include "data_mem.sv"
//`include "IO/IOport.sv"
//`include "IO/mux7seg.sv"
module DataMemoryDecoder (
    input   logic   clk,
    input   logic   write_EN,
    input   logic   [31:0]data_addr,
    input   logic   [31:0]write_data,
    output  logic   [31:0]read_data,

    input   logic   rst,
    input   logic   buttonL,
    input   logic   buttonR,
    input   logic   [15:0]switch,
    output  logic   [7:0]AN,
    output  logic   DP,
    output  logic   [6:0]A2G
);
    logic mem_we, pWrite;
    logic [31:0] mem_read_data, IOStatus_data;
    logic [11:0]led;

    // select write engine
//    sel2 selWE(
//        .in(write_EN),
//        .selector(data_addr[7]),
//        .out0(mem_we),
//        .out1(pWrite)
//    );
    assign mem_we = write_EN & (data_addr[7] == 1'b0);
    assign pWrite = (data_addr[7] == 1'b1)? write_EN: 0;

    data_mem data_mem(
        .clk(clk),
        .we(mem_we),
        .data_addr(data_addr),
        .write_data(write_data),
        .read_data(mem_read_data)
    );

    IOport ioport(
        .clk(!clk),
        .rst(rst),
        .pRead(data_addr[7]),
        .pWrite(pWrite),
        .addr(data_addr[3:2]),
        .pWriteData(write_data),
        .pReadData(IOStatus_data),
        .buttonL(buttonL),
        .buttonR(buttonR),
        .switch(switch),
        .led(led)
    );

    mux7seg mux7seg(
        .CLK100MHZ(!clk),
        .reset(rst),
        .digit({switch, 4'b0000, led}),
        .AN(AN),
        .DP(DP),
        .A2G(A2G)
    );

    // data output    
    mux2 rdData(
        .selector(data_addr[7]),
        .s0(mem_read_data),
        .s1(IOStatus_data),
        .result(read_data)
    );

endmodule