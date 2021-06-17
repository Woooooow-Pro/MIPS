module state_switch (
    input   logic   last_taken,
    input   logic   [1:0]pre_state,

    output  logic   [1:0]next_state
);
    always_comb begin
        case(pre_state)
            2'b00: next_state = last_taken? 2'b01: 2'b00;
            2'b11: next_state = last_taken? 2'b11: 2'b10;
            default: next_state = last_taken? pre_state + 1: pre_state - 1;
        endcase
    end    

endmodule: state_switch