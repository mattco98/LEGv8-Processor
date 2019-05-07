`timescale 1ns / 1ps
`include "constants.vh"


module multiplier #(parameter SIZE=`WORD) (
    input  clk,
    input  start,
    input  reset,
    input  [SIZE-1:0] a,
                      b,
    output reg [SIZE-1:0] result,
    output reg stall,
    output reg done
);

    reg active;
    reg beginning;
    reg [SIZE-1:0] multiplicand;
    reg [SIZE*2-1:0] product;
    reg [SIZE:0] i;
    
    always @(posedge reset) begin
        stall <= 0;
        result <= 'b0;
        active <= 0;
        beginning <= 1;
    end
    
    always @(posedge clk) begin
        if (start) begin
            if (beginning) begin
                beginning <= 0;
                active <= 1;
                multiplicand <= b;
                product <= {{SIZE{1'b0}}, a};
                i <= 0;
                stall <= 1;
            end
        end else if (active) begin
            if (i == SIZE) begin
                stall <= 0;
                active <= 0;
                result <= product[SIZE-1:0];
                done <= 1;
            end else begin
                product <= product[0] == 1'b1 ? 
                    (({(product[SIZE*2-1:SIZE] + multiplicand), product[SIZE-1:0]}) >> 1) : 
                    (product >> 1);
                i <= i + 1;
            end
        end else if (~active) begin
            done <= 0;
            stall <= 0;
            beginning <= 1;
        end
    end
    
//    always @(posedge start) begin
//        active <= 1;
//        multiplicand <= b;
//        product <= {{SIZE{1'b0}}, a};
//        i <= 0;
//        #(`CYCLE/2) stall <= 1; // TODO: Is there a way to eliminate this delay?
//    end

//    always @(posedge clk) begin
//        if (active) begin
//            if (i == SIZE) begin
//                stall <= 0;
//                active <= 0;
//                result <= product[SIZE-1:0];
//                done <= 1;
//            end else begin
//                product <= product[0] == 1'b1 ? 
//                    (({(product[SIZE*2-1:SIZE] + multiplicand), product[SIZE-1:0]}) >> 1) : 
//                    (product >> 1);
//                i <= i + 1;
//            end
//        end else begin
//            done <= 0;
//            stall <= 0;
//        end
//    end

endmodule







