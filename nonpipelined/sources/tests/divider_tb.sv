`timescale 1ns / 1ps
`include "constants.vh"


module divider_tb;
    localparam SIZE = 16;

    wire            clk;
    reg             reset;
    reg             start;
    reg             is_signed;
    reg  [SIZE-1:0] dividend;
    reg  [SIZE-1:0] divisor;
    wire [SIZE-1:0] quotient;
    wire [SIZE-1:0] remainder;
    wire            stall;
    wire            done;
    
    oscillator clk_gen(clk);
    
    divider #(SIZE) UUT(.*);
    
    initial begin
        is_signed <= 1;
        dividend <= -'d24487;
        divisor <= 'd83;
        reset <= 1;
        start <= 0;
        #`CYCLE;
        
        reset <= 0;
        #`CYCLE;
        
        start <= 1;
        #`CYCLE;
        
        start <= 0;
        #(`CYCLE * 20);
        
        $finish;
    end

endmodule