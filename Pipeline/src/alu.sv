module alu #(parameter Width = 32)(
    input   [Width-1:0] a_i,
    input   [Width-1:0] b_i,
    input   [2:0]      alu_control_i,
    output  logic   [Width-1:0] result_o
);
    always_comb begin
        case(alu_control_i)
            3'b000:   result_o = a_i & b_i;     // 0: and
            3'b001:   result_o = a_i | b_i;     // 1: or
            3'b010:   result_o = a_i + b_i;     // 2: add
            3'b011:   result_o = a_i << b_i;    // 3: sll
            3'b100:   result_o = a_i >> b_i;    // 4: srl
            3'b101:   result_o = $signed(a_i) >>> b_i;  // 5: sra
            3'b110:   result_o = a_i - b_i;     // 6: sub
            3'b111:   result_o = $signed(a_i) < $signed(b_i);  // 7: slt
        default: result_o = 3'd0;
        endcase
    end

endmodule: alu