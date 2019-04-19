`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"

module register_memory #(parameter PATH=`REGISTERS_FILE)(
    input read_clk,
    input write_clk,
    input reset,
    input reg_write,
    input [4:0] read_reg1, read_reg2, write_reg,
    input [`WORD-1:0] write_data,
    output reg [`WORD-1:0] read_data1, read_data2
);
    
    reg [`WORD-1:0] register_mem [`WORD-1:0];
    
    initial $readmemb(PATH, register_mem);
    
    always @(posedge read_clk or posedge reset) begin
        if (~reset) begin
            read_data1 <= register_mem[read_reg1];
            read_data2 <= register_mem[read_reg2];
        end
    end
    
    always @(posedge write_clk or posedge reset) 
        if (~reset && reg_write) register_mem[write_reg] <= write_data;
    
endmodule
