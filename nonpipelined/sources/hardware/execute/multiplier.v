`timescale 1ns / 1ps
`include "constants.vh"


module multiplier #(parameter SIZE=`WORD)(
    input clk,
          reset,
          start,
    input [SIZE-1:0] multiplicand, 
                     multiplier,
    input [1:0] mult_mode,
    output [SIZE-1:0] result,
    output reg done,
    output stall
);

    reg [SIZE*2:0]    product;
    assign result = reset ? 'b0 : (mult_mode == 2'b00 ? product[SIZE-1:0] : product[SIZE*2-1:SIZE]);

    reg [SIZE/2:0] bit; 
    //assign done = !bit && stall;
    assign stall = bit != 0;
    reg carry;

    wire [SIZE:0]   multsx = {mult_mode == 2'b10 ? multiplicand[SIZE-1] : 1'b0, multiplicand};
    
    always @(posedge reset) begin
        bit = 0;
    end

    always @(posedge clk) begin
        if (start) begin
            bit = SIZE/2;
            product = {{(SIZE+1){1'd0}}, multiplier};
            carry = 0;
        end else if (bit) begin
            case ({product[1:0], carry})
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
            done = bit == 0;
        end else if (done)
            done = 0;
    end

endmodule

