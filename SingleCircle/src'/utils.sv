module signex (
    input   logic [15:0]    a,
    output  logic [31:0]    y
);
    assign y = {{16{a[15]}}, a};
endmodule

// 32-bit adder
module adder(
    input  logic [31:0] a_i, b_i,
    output logic [31:0] result_o
);
    assign result_o = a_i + b_i;
endmodule

// 2 to 1 multiplexer
module mux2 #(parameter Width = 32) (
    input  logic [Width-1:0] data0_i, data1_i,
    input  logic select_i,
    output logic [Width-1:0] result_o
);
    assign result_o = select_i? data0_i: data1_i;
endmodule

