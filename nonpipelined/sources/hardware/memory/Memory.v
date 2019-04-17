`timescale 1ns / 1ps
`include "constants.vh"


module Memory(
    input  read_clk,
           write_clk,
           uncondbranch,
           branch,
           zero,
           mem_read,
           mem_write,
    input  [`WORD-1:0] address,
                       write_data,
    output pc_src,
    output [`WORD-1:0] read_data
);

    assign pc_src = uncondbranch || (branch && zero);
    
    data_memory DATA_MEM(
        .read_clk(read_clk),
        .write_clk(write_clk),
        .address(address),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(read_data),
        .write_data(write_data)
    );

endmodule
