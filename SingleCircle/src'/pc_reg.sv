//
module flip_flop #(parameter Width = 8;)(
    input  logic clk, reset,
    input  logic [Width-1:0]   d_i,
    output logic [Width-1:0]   q_o
);
    always_ff @(posedge clk, posedge reset)
        if(reset)
            q_o <= 0;
        else
            q_o <= d_i;
endmodule