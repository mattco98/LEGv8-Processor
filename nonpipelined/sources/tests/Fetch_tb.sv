`timescale 1ns / 1ps
`include "constants.vh"
`include "helpers.vh"

module Fetch_tb;

    wire clk, instr_mem_clk;
    reg  reset, pc_src;
    reg  [`WORD-1:0] branch_target;
    wire [`WORD-1:0] cur_pc;
    wire [`INSTR_LEN-1:0] instruction;
    
    oscillator clk_gen(clk);
    
    delay #(1) instr_clk_gen(
        .clk(clk),
        .clk_delayed(instr_mem_clk)
    );
    
    Fetch UUT(.*);
    
    initial begin
        `TB_BEGIN
        
        reset <= 0;
        pc_src <= 0;
        branch_target <= 0;
        #`CYCLE;
        
        pc_src <= 1;
        branch_target <= 'd36;
        #`CYCLE;
        assert(cur_pc == 'd36);
        
        pc_src <= 0;
        branch_target <= 'd44;
        #`CYCLE;
        assert(cur_pc == 'd40);
       
        pc_src <= 1;
        branch_target <= 'd24;
        #`CYCLE;
        assert(cur_pc == 'd24);
        
        `TB_END
        $finish;
    end

endmodule
