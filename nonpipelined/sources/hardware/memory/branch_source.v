`timescale 1ns / 1ps
`include "constants.vh"


module branch_source(
    input [10:0] opcode,
    input zero, branch, branch_if_zero, branch_if_not_zero,
    output reg branch_src
);

    always @* begin
        branch_src <= 0;
    
        if (branch)
            branch_src <= 1;
        else if (branch_if_zero && zero == 1)
            branch_src <= 1;
        else if (branch_if_not_zero && zero == 0)
            branch_src <= 1;
        
        /*
        casex(opcode)
            `B.COND1: ...
            `B.COND2: ...
        endcase
        */
    end

endmodule
