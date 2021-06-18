module hazard_unit (
    input   logic   [4:0]rs_d,
    input   logic   [4:0]rt_d,
    input   logic   [1:0]branch_d,
    input   logic   pc_src_d,
    input   logic   [1:0]jump_d,
    input   logic   [4:0]rs_e,
    input   logic   [4:0]rt_e,
    input   logic   [4:0]reg_write_addr_e,
    input   logic   sel_reg_write_data_e,
    input   logic   reg_we_e,
    input   logic   [4:0]reg_write_addr_m,
    input   logic   sel_reg_write_data_m,
    input   logic   reg_we_m,
    input   logic   [4:0]reg_write_addr_w,
    input   logic   reg_we_w,

    input   logic   predict_miss,

    output  logic   stall_f,
    output  logic   stall_d,
    output  logic   flush_d,
    output  logic   forward_a_d,
    output  logic   forward_b_d,
    output  logic   flush_e,
    output  logic   [1:0]forward_a_e,
    output  logic   [1:0]forward_b_e
);
    logic lw_stall, branch_stall;
    // Solves data hazards with forwarding
    always_comb begin
        if (rs_e && rs_e == reg_write_addr_m && reg_we_m) begin
            forward_a_e = 2'b10;
        end
        else if (rs_e && rs_e == reg_write_addr_w && reg_we_w) begin
            forward_a_e = 2'b01;
        end
        else begin
            forward_a_e = 2'b00;
        end

        if (rt_e && rt_e == reg_write_addr_m && reg_we_m) begin
            forward_b_e = 2'b10;
        end
        else if (rt_e && rt_e == reg_write_addr_w && reg_we_w) begin
            forward_b_e = 2'b01;
        end
        else begin
            forward_b_e = 2'b00;
        end
    end

    // Solves control hazards with forwarding
    assign forward_a_d = rs_d && rs_d == reg_write_addr_m && reg_we_m;
    assign forward_b_d = rt_d && rt_d == reg_write_addr_m && reg_we_m;

    // Solves data hazards with stalls
    assign lw_stall = (rs_d == rt_e || rt_d == rt_e) && sel_reg_write_data_e;

    // Solves control hazards with stalls
    assign branch_stall = (branch_d || jump_d[1])
        && (reg_we_e && (rs_d == reg_write_addr_e || rt_d == reg_write_addr_e)
        || sel_reg_write_data_m && (rs_d == reg_write_addr_m || rt_d == reg_write_addr_m));

    assign stall_d = (branch_stall || lw_stall) === 'X ? 1'b0 : (lw_stall || branch_stall);
    assign flush_e = stall_d || predict_miss;
    assign flush_d = predict_miss || jump_d[1];
    assign stall_f = stall_d;

endmodule: hazard_unit