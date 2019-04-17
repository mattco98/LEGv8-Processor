`timescale 1ns / 1ps
`include "constants.vh"

module Decode_tb;

    wire read_clk, write_clk;
    reg  [`INSTR_LEN-1:0] instruction;
    reg  [`WORD-1:0] write_data;
    
    wire [`WORD-1:0] extended_instruction;
    wire [10:0] opcode;
    wire [`WORD-1:0] read_data1, read_data2;
    
    wire unconditional_branch, branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write;
    wire [1:0] alu_op;
    
    oscillator clk_gen(read_clk);
    
    delay #(2) write_clk_gen(read_clk, write_clk);
    
    Decode DECODE(.*);
    
    initial begin
        // LDUR X9, [X22, #64]
        instruction <= 32'hF84402C9;
        write_data <= `WORD'd20;
        #`CYCLE;
        
        // ADD X10, X19, X9
        instruction <= 32'h8B09026A;
        write_data <= `WORD'd30;
        #`CYCLE;
        
        // SUB X11, X20, X10
        instruction <= 32'hCB0A028B;
        write_data <= `WORD'd0;
        #`CYCLE;
        
        // STUR X11, [X22, #96]
        instruction <= 32'hF80602CB;
        #`CYCLE;
        
        // CBZ X11, -5
        instruction <= 32'hB4FFFF6B;
        #`CYCLE;
        
        // CBZ X9, 8
        instruction <= 32'hB4000109;
        #`CYCLE;
        
        // B 64
        instruction <= 32'h14000040;
        #`CYCLE;
        
        // B -55
        instruction <= 32'h17FFFFC9;
        #`CYCLE;
        
        // ORR X9, X10, X21
        instruction <= 32'hAA150149;
        write_data <= `WORD'd30;
        #`CYCLE;
        
        // AND X9, X22, X10
        instruction <= 32'h8A0A02C9;
        write_data <= `WORD'd16;
        #`CYCLE;
        
        $finish;
    end

endmodule
