`timescale 1ns / 1ps
`include "constants.vh"


module multiplier_tb;

    wire clk;
    wire stall;
    reg reset;
    reg [1:0] mult_mode;
    reg [7:0] multiplicand, multiplier;
    reg start;
    wire [7:0] result;
    wire done;
    
    oscillator clk_gen(clk);

    multiplier #(8) UUT(.*);
    
    initial begin
        mult_mode <= 'd10;
        multiplicand <= 'b00000101;
        multiplier <= 'b00001100;
        reset <= 1;
        start <= 0;
        #`CYCLE;
        reset <= 0;
        #`CYCLE;
        start <= 1;
        #`CYCLE;
        start <= 0;
        
        #(`CYCLE*70);
    
    
        $finish;
    end

endmodule
