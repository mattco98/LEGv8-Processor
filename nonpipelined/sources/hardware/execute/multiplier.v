`timescale 1ns / 1ps
`include "constants.vh"

// http://www.ece.lsu.edu/ee3755/2002/l07.html
// Taken from imult_Booth_radix_4 module
module multiplier#(parameter SIZE=`WORD)(
    input  clk,
           reset,
           start,
    input  [1:0] mult_mode,
    input  [SIZE-1:0] multiplicand, multiplier,
    output [SIZE-1:0] result,
    output done,
    output stall
);

    reg [SIZE*2:0] product;
    reg [10:0] bit;
    reg carry;
    reg stall_internal;
    wire [SIZE:0] multsx = {multiplicand[SIZE-1],multiplicand};
   
    // TODO: Do different things for UMULH (mult_mode == 'b01) and SMULH (mult_mode == 'b10) ???
    assign result = (mult_mode == 'b00) ? product[SIZE-1:0] : product[SIZE*2-1:SIZE]; 
    assign done = !bit && stall_internal;
    assign stall = bit != 0;
    
    always @(posedge clk, reset) begin
        if (reset) begin
            product = 0;
            bit = 0;
            carry = 0;
            stall_internal = 0;
        end else if (start) begin
            bit = SIZE/2;
            product = {{(SIZE + 1){1'd0}}, multiplier};
            carry = 0;
            stall_internal = 1;
         end else if (bit) begin
            case({product[1:0], carry})
              3'b001: product[SIZE*2:SIZE] = product[SIZE*2:SIZE] + multsx;
              3'b010: product[SIZE*2:SIZE] = product[SIZE*2:SIZE] + multsx;
              3'b011: product[SIZE*2:SIZE] = product[SIZE*2:SIZE] + 2 * multiplicand;
              3'b100: product[SIZE*2:SIZE] = product[SIZE*2:SIZE] - 2 * multiplicand;
              3'b101: product[SIZE*2:SIZE] = product[SIZE*2:SIZE] - multsx;
              3'b110: product[SIZE*2:SIZE] = product[SIZE*2:SIZE] - multsx;
            endcase
    
            carry = product[1];
            product = {{2{product[SIZE*2]}}, product[SIZE*2:2]};
            bit = bit - 1;
        end else if (stall_internal) begin
            stall_internal = 0;
        end
    end

endmodule
