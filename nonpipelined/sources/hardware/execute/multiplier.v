`timescale 1ns / 1ps
`include "constants.vh"


module multiplier #(parameter SIZE=`WORD) (
    input  clk,
    input  start,
    input  [SIZE-1:0] a,
                      b,
    output reg [SIZE-1:0] result,
    output reg stall
);

    reg active;
    reg [SIZE-1:0] multiplicand;
    reg [SIZE*2-1:0] product;
    reg [SIZE:0] i;
    
    always @(posedge start) begin
        active <= 1;
        stall <= 1;
        multiplicand <= b;
        product <= {{SIZE{1'b0}}, a};
        i <= 0;
        result <= 'b0;
    end

    always @(posedge clk) begin
        if (active) begin
            if (i == SIZE) begin
                stall <= 0;
                active <= 0;
                result <= product[SIZE-1:0];
            end else begin
                product <= product[0] == 1'b1 ? 
                    (({(product[SIZE*2-1:SIZE] + multiplicand), product[SIZE-1:0]}) >> 1) : 
                    (product >> 1);
                i <= i + 1;
            end
        end
    end

endmodule







