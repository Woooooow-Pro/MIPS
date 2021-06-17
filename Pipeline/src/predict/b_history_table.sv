module branch_history_table #(
    parameter SIZE_WIDTH = 10,
    parameter INDEX_WIDTH = 10
)(
    input   logic   clk,
    input   logic   rst,
    input   logic   en,
    input   logic   update_en,
    input   logic   last_taken,
    input   logic   [INDEX_WIDTH-1:0]index,

    output  logic   [1:0]state
);
    localparam SIZE = 2**SIZE_WIDTH;

    logic [1:0]entries[SIZE-1:0];
    logic [1:0]entry;
    logic [INDEX_WIDTH-1:0]last_index;

    assign state = entries[index];

    state_switch stateSwitch(
        .last_taken(last_taken),
        .pre_state(entries[last_index]),
        .next_state(entry)
    );

    always_ff @( posedge clk ) begin
        if(rst) begin
            entries <= '{default: '0};
            last_index <= '0;
        end

        else if (en) begin
            if(update_en) begin
                entries[last_index] <= entry;
            end

            last_index <= index;
        end
    end
endmodule: branch_history_table