`timescale 1ns / 1ps
`include "constants.vh"

module status_register(
    input clk,
          reset,
          negative,
          zero,
          carry,
          overflow,
    output [31:0] sreg
);

    reg [31:0] sreg_buffered;

    register STATUS_REG(
        .clk(clk),
        .reset(reset),
        .D(sreg_buffered),
        .Q(sreg)
    );
    
    initial
        sreg_buffered <= 32'b0;
    
    always @(posedge clk or posedge reset) begin
        if (negative)
            sreg_buffered = sreg_buffered | (1 << 31);
        else
            sreg_buffered = sreg_buffered & 32'h7FFFFFFF;
            
        if (zero)
            sreg_buffered = sreg_buffered | (1 << 30);
        else
            sreg_buffered = sreg_buffered & 32'hBFFFFFFF;
            
        if (carry)
            sreg_buffered = sreg_buffered | (1 << 29);
        else
            sreg_buffered = sreg_buffered & 32'hDFFFFFFF;
            
        if (overflow)
            sreg_buffered = sreg_buffered | (1 << 28);
        else
            sreg_buffered = sreg_buffered & 32'hEFFFFFFF;
            
        if (reset) 
            sreg_buffered = 32'b0;
        
    end

endmodule
