`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"

module instruction_mem_tb;

    wire clk;
    reg  [`WORD-1:0] address;
    wire [`INSTR_LEN-1:0] instruction;
    
    oscillator clk_gen(clk);
    
    instruction_mem UUT(
        .clk(clk),
        .address(address),
        .instruction(instruction)
    );
    
    initial begin
        repeat(64) begin // 1024 is too much console spam
            @(negedge clk)
            #1 assert(instruction == address / 4);
 
            address = address + 4;
        end
        
        $finish;
    end

endmodule
