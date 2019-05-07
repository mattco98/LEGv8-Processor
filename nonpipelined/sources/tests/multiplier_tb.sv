`timescale 1ns / 1ps
`include "constants.vh"


module multiplier_tb;

    wire clk;
    reg  start;
    reg  [`WORD-1:0] a, b;
    wire [`WORD-1:0] result;
    wire stall;
    
    oscillator clk_gen(clk);

    multiplier #(`WORD) UUT(.*);
    
    initial begin
        a <= 'd27;
        b <= 'd92;
        #`CYCLE;
        
        start <= 1;
        
        #(`CYCLE*65);
        $finish;
    end

endmodule
