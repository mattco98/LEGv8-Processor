`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"


module register_memory #(parameter PATH=`REGISTER_FILE)(
    input                  read_clk,
    input                  write_clk,
    input                  reset,
    input                  reg_write,
    input      [4:0]       read_reg1,
    input      [4:0]       read_reg2,
    input      [4:0]       write_reg,
    input      [`WORD-1:0] write_data,
    output reg [`WORD-1:0] read_data1,
    output reg [`WORD-1:0] read_data2
);
    
    reg [`WORD-1:0] register_mem [31:0];
    
    initial 
        $readmemb(PATH, register_mem);
    
    always @(posedge read_clk, reset) 
        if (!reset) begin
            read_data1 <= register_mem[read_reg1];
            read_data2 <= register_mem[read_reg2];
        end
    
    always @(posedge write_clk, reset) 
        if (!reset && reg_write) 
            register_mem[write_reg] <= write_data;
    
endmodule
