`timescale 1ns / 1ps
`include "files.vh"
`include "constants.vh"

module data_memory #(parameter PATH=`RAM_FILE, parameter SIZE=1024)(
    input  [`WORD-1:0] address,
                       write_data,
    input  mem_read,
           mem_write,
           read_clk,
           write_clk,
    output reg [`WORD-1:0] read_data
);

    reg [`WORD-1:0] data_mem [SIZE-1:0];
    
    initial $readmemb(PATH, data_mem);
    
    always @(posedge read_clk)
        read_data <= (mem_read ? data_mem[address / 8] : 64'bZ);
        
    always @(posedge write_clk)
        if (mem_write) data_mem[address / 8] <= write_data;

endmodule