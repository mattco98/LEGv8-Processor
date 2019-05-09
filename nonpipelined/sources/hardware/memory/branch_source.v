`timescale 1ns / 1ps
`include "constants.vh"
`include "helpers.vh"


module branch_source(
    input      [4:0] conditional_branch,
    input      [2:0] branch_op,
    input            zero, 
    input            negative,
    input            overflow, 
    input            carry,
    output reg [1:0] branch_src
);

    always @* begin
        branch_src <= 'b00;
        
        case(branch_op)
            `BCOND_OP_BRANCH:
                branch_src <= 'b01;
            `BCOND_OP_ZERO:
                if (zero)
                    branch_src <= 'b01;
            `BCOND_OP_NZERO:
                if (!zero)
                    branch_src <= 'b01;
            `BCOND_OP_ALU:
                branch_src <= 'b10;
            `BCOND_OP_NOINC:
                branch_src <= 'b11;
            `BCOND_OP_COND:
                case(conditional_branch)
                    `BCOND_EQ: branch_src <= zero == 1; 
                    `BCOND_NE: branch_src <= zero == 0;
                    `BCOND_CS: branch_src <= carry == 1;
                    `BCOND_CC: branch_src <= carry == 0;
                    `BCOND_MI: branch_src <= negative == 1;
                    `BCOND_PL: branch_src <= negative == 0;
                    `BCOND_VS: branch_src <= overflow == 1;
                    `BCOND_VC: branch_src <= overflow == 0;
                    `BCOND_HI: branch_src <= (carry == 1) && (zero == 0);
                    `BCOND_LS: branch_src <= (carry == 0) || (zero == 0);
                    `BCOND_GE: branch_src <= negative == overflow;
                    `BCOND_LT: branch_src <= negative != overflow;
                    `BCOND_GT: branch_src <= (zero == 0) && (negative == overflow);
                    `BCOND_LE: branch_src <= (zero == 1) || (negative != overflow);
                    `BCOND_NV: branch_src <= 'b0;
                    `BCOND_AL: branch_src <= 'b1;
                    default:   branch_src <= 'b0;
                endcase
        endcase
    end

endmodule
