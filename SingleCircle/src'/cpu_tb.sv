` include"cpu.sv"

module testbench (
);
    logic clk;
    logic reset;
    logic [31:0] writedata, dataadr;
    logic memwrite;

    cpu  cpu(
        .clk(clk),
        .reset(reset),
        .writedata(writedata),
        .dataadr(dataadr),
        .memwrite(memwrite)
    );

    initial begin
        reset <= 1;
    end

    always begin
        if(memwrite) begin
            if(dataadr === 84 & writedata === 7) begin
                $display("Simulation succeeded");
                $stop;
            end
            else if(dataadr !== 80) begin
                $siaplay("Simulation failed");
                $stop;
            end
        end
    end
    
endmodule