`timescale 1ns / 1ps
`include "constants.vh"


module multiplier #(parameter SIZE=`WORD)(
    input [SIZE-1:0] multiplicand, multiplier,
    input start, clk,
    input [1:0] mult_mode,
    output [SIZE-1:0] result,
    output ready
);

   reg [SIZE*2:0]    product;
   assign result = mult_mode == 2'b00 ? product[SIZE-1:0] : product[SIZE*2-1:SIZE];

   reg [SIZE/2:0] bit; 
   assign ready = !bit;
   reg lostbit;
   
   initial bit = 0;

   wire [SIZE:0]   multsx = {mult_mode == 2'b10 ? multiplicand[SIZE-1] : 1'b0 ,multiplicand};

   always @( posedge clk )

     if( ready && start ) begin

        bit     = SIZE/2;
        product = { {(SIZE+1){1'd0}}, multiplier };
        lostbit = 0;
        
     end else if( bit ) begin:A

        case ( {product[1:0],lostbit} )
          3'b001: product[SIZE*2:SIZE] = product[SIZE*2:SIZE] + multsx;
          3'b010: product[SIZE*2:SIZE] = product[SIZE*2:SIZE] + multsx;
          3'b011: product[SIZE*2:SIZE] = product[SIZE*2:SIZE] + 2 * multiplicand;
          3'b100: product[SIZE*2:SIZE] = product[SIZE*2:SIZE] - 2 * multiplicand;
          3'b101: product[SIZE*2:SIZE] = product[SIZE*2:SIZE] - multsx;
          3'b110: product[SIZE*2:SIZE] = product[SIZE*2:SIZE] - multsx;
        endcase

        lostbit = product[1];
        product = { {2{product[SIZE*2]}}, product[SIZE*2:2] };
        bit     = bit - 1;

     end

endmodule

