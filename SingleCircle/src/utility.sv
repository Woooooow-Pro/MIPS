// signal extension
module sign_extension #(
    parameter Width = 16
)(
    input   logic   [Width-1:0]in,
    output  logic   [31:0]out
);
    assign out = {{(32-Width){in[Width-1]}}, in};
endmodule

// unsignal extension
module unsign_extension #(
    parameter Width = 5
)(
    input   logic   [Width-1:0]in,
    output  logic   [31:0]out
);
    assign out = {{(32-Width){1'b0}}, in};
endmodule

// 2:1 mux
module mux2 #(
    parameter Width = 32
)(
    input   logic   selector,
    input   logic   [Width - 1:0]s0,
    input   logic   [Width - 1:0]s1,
    output  logic   [Width - 1:0]result
);
    assign result = selector? s1: s0;
endmodule

// 4:1 mux
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
endmodule

// 1:2 sel

// module sel2 (
//     input   logic   in,
//     input   logic   selector,
//     output  logic   out0,
//     output  logic   out1
// );
//     assign out0 = selector == 0? in: 0;
//     assign out1 = selector == 1? in: 0;
// endmodule

// left shift 2
module lshift2 (
    input   logic   [31:0]in,
    output  logic   [31:0]out
);
    assign out = {in[29:0], 2'b00};
endmodule

// adder
module adder (
    input   logic   [31:0] a,
    input   logic   [31:0] b,
    output  logic   [31:0] result
);
    assign result = a + b;
endmodule

// flip flop
module flip_flop (
    input   logic   clk, rst,
    input   logic   [31:0]in,
    output  logic   [31:0]out
);
    always_ff @(posedge clk, posedge rst) begin
        if(rst)
            out <= 0;
        else
            out <= in;
    end
endmodule