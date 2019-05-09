`timescale 1ns / 1ps
`include "constants.vh"


module multiplier_tb;

    wire clk;
    wire stall;
    reg reset;
    reg [1:0] mult_mode;
    reg [63:0] multiplicand, multiplier;
    reg start;
    wire [64:0] result;
    wire done;
    
    oscillator clk_gen(clk);

    multiplier UUT(.*);
    
    initial begin
        mult_mode <= 'd00;
        multiplicand <= -'d78;
        multiplier <= 'd99;
        reset <= 1;
        start <= 0;
        #`CYCLE;
        reset <= 0;
        #`CYCLE;
        start <= 1;
        #`CYCLE;
        start <= 0;
        
        #(`CYCLE*50);
    
    
        $finish;
    end

endmodule
