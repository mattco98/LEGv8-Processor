`timescale 1ns / 1ps
`include "constants.vh"

module status_register(
    input clk,
          reset,
          negative_in,
          zero_in,
          carry_in,
          overflow_in,
          negative_out,
          zero_out,
          carry_out,
          overflow_out,
          update_sreg,
    output [31:0] sreg
);

    reg [31:0] sreg_buffered;
    
    assign negative_out = sreg[31];
    assign zero_out = sreg[30];
    assign carry_out = sreg[29];
    assign overflow_out = sreg[28];

    register STATUS_REG(
        .clk(clk),
        .reset(reset),
        .D(sreg_buffered),
        .Q(sreg)
    );
    
    initial
        sreg_buffered <= 32'b0;
    
    always @(posedge clk or posedge reset) begin
        if (update_sreg) begin
            if (negative_out)
                sreg_buffered = sreg_buffered | (1 << 31);
            else
                sreg_buffered = sreg_buffered & 32'h7FFFFFFF;
                
            if (zero_out)
                sreg_buffered = sreg_buffered | (1 << 30);
            else
                sreg_buffered = sreg_buffered & 32'hBFFFFFFF;
                
            if (carry_out)
                sreg_buffered = sreg_buffered | (1 << 29);
            else
                sreg_buffered = sreg_buffered & 32'hDFFFFFFF;
                
            if (overflow_out)
                sreg_buffered = sreg_buffered | (1 << 28);
            else
                sreg_buffered = sreg_buffered & 32'hEFFFFFFF;
        end
            
        if (reset) 
            sreg_buffered = 32'b0;
        
    end

endmodule
