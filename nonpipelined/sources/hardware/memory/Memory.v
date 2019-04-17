`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"


module Memory #(parameter PATH=`RAM_FILE) (
    input  read_clk,
           write_clk,
           branch,
           branch_if_zero,
           branch_if_not_zero,
           zero,
           mem_read,
           mem_write,
    input  [`WORD-1:0] address,
                       write_data,
    output pc_src,
    output [`WORD-1:0] read_data
);

    assign pc_src = branch || (branch_if_zero && zero) || (branch_if_not_zero && ~zero);
    
    data_memory #(PATH) DATA_MEM(
        .read_clk(read_clk),
        .write_clk(write_clk),
        .address(address),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .read_data(read_data),
        .write_data(write_data)
    );

endmodule
