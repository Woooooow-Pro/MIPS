module cpu (
    input   logic   clk,
    input   logic   rst
);
    logic mem_we;
    logic [31:0]instr, mem_read_data, pc, mem_data_addr, mem_write_data;

    mips u_mips(
        .clk,
        .rst,
        .instr,
        .mem_read_data,
        .pc,
        .mem_we,
        .mem_data_addr,
        .mem_write_data
    );
    
    data_mem dataMemory(
        .clk,
        .we(mem_we),
        .data_addr(mem_data_addr),
        .write_data(mem_write_data),
        .read_data(mem_read_data)
    );
    instr_mem instrMemory(
        .pc_addr(pc[7:2]),
        .instr
    );
endmodule: cpu