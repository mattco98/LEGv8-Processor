`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"

module register_memory #(parameter PATH=`REGISTERS_FILE)(
    input read_clk,
    input write_clk,
    input reg_write,
    input [4:0] read_reg1, read_reg2, write_reg,
    input [`WORD-1:0] write_data,
    output reg [`WORD-1:0] read_data1, read_data2
);
    
    reg [31:0] register_memory [`WORD-1:0];
    
    initial $readmemb(PATH, register_memory);
    
    always @(posedge read_clk) begin
        read_data1 <= register_memory[read_reg1];
        read_data2 <= register_memory[read_reg2];
    end
    
    always @(posedge write_clk) 
        if (reg_write) register_memory[write_reg] <= write_data;
    
endmodule
