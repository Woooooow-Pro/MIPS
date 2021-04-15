module IOport (
    input   logic   clk,
    input   logic   rst,
    input   logic   pRead,
    input   logic   pWrite,
    input   logic   [1:0]addr,
    input   logic   [31:0]pWriteData,
    output  logic   [31:0]pReadData,
    input   logic   buttonL,
    input   logic   buttonR,
    input   logic   [15:0]switch,
    output  logic   [11:0]led
);
    
    logic   [1:0]reg_status;
    logic   [15:0]reg_switch;
    logic   [11:0]reg_led;

    always_ff @( posedge clk ) begin
        if(rst) begin
            reg_status  <= 2'b00;
            reg_switch  <= 16'h00;
            reg_led     <= 12'b0000_0000_0000;
        end
        else begin
            // input new data
            if(buttonR) begin
                reg_status[1] <= 1;
                reg_switch <= switch;
            end
            
            // output led data
            if(buttonL) begin
                reg_status[0] <= 1;
                led <= reg_led;
//                led <= 12'b1111_1111_1111;
            end

            // read output data
            if(pWrite & (addr == 2'b01)) begin
                reg_led <= pWriteData[11:0];
                reg_status[0] <= 0;
            end
            
            // read data
            if(pRead) begin
                // 00: read status
                // 01: read led;
                // 10: read low
                // 11: read high
                case (addr)
                    2'b00: pReadData <= {24'b0, 6'b0, reg_status};
                    2'b01: pReadData <= 32'b0;
                    2'b10: pReadData <= {24'b0, reg_switch[7:0]};
                    2'b11: pReadData <= {24'b0, reg_switch[15:8]};
                endcase
            end// end read data

        end
    end // end of always_ff
endmodule