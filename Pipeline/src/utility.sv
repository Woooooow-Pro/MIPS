// signal extension
module sign_extension #(
    parameter Width = 16
)(
    input   logic   [Width-1:0]in,
    output  logic   [31:0]out
);
    assign out = {{(32-Width){in[Width-1]}}, in};
endmodule: sign_extension

// unsignal extension
module unsign_extension #(
    parameter Width = 5
)(
    input   logic   [Width-1:0]in,
    output  logic   [31:0]out
);
    assign out = {{(32-Width){1'b0}}, in};
endmodule: unsign_extension

// adder
module adder (
    input   logic   [31:0] a,
    input   logic   [31:0] b,
    output  logic   [31:0] result
);
    assign result = a + b;
endmodule: adder

// equality comparator
module equal_cmp #(
    parameter Width = 32
)(
    input   logic   [31:0]in_1, in_2,
    output  logic   out
);
    assign out = in_1 == in_2? 1: 0;
endmodule: equal_cmp

// 2-to-1 multiplexer
module mux2 #(
    parameter Width = 32
)(
    input   logic   selector,
    input   logic   [Width - 1:0]s0,
    input   logic   [Width - 1:0]s1,
    output  logic   [Width - 1:0]result
);
    assign result = selector? s1: s0;
endmodule: mux2

// 4-to-1 multiplexer
module mux4 #(
    parameter Width = 32
)(
    input   logic   [1:0]selector,
    input   logic   [Width - 1:0]s0,
    input   logic   [Width - 1:0]s1,
    input   logic   [Width - 1:0]s2,
    input   logic   [Width - 1:0]s3,
    output  logic   [Width - 1:0]result
);
    always_comb begin
        case (selector)
            2'b00:   result = s0;
            2'b01:   result = s1;
            2'b10:   result = s2;
            2'b11:   result = s3;
            default: result = 0;
        endcase
    end
endmodule: mux4

// flip flop
module flip_flop #(
parameter WIDTH = 32
)(
    input   logic   clk, rst,
    input   logic   we,
    input   logic   clr,
    input   logic   [WIDTH - 1:0]in,
    output  logic   [WIDTH - 1:0]out
);
    always_ff @(posedge clk or posedge rst) begin
        if(rst || clr)
            out <= 0;
        else if(we)
            out <= in;
    end
endmodule: flip_flop