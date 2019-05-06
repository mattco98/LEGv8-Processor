`timescale 1ns / 1ps
`include "constants.vh"


module Writeback(
    input  [`WORD-1:0] alu_result,
                       read_data,
                       incremented_pc,
    input  [1:0] mem_to_reg,
    input  [10:0] opcode,
    output reg [`WORD-1:0] write_back
);

    always @* begin
        casex(opcode)
            `LDURB:  write_back <= {{(`WORD - 8){1'b0}},  read_data[7:0]};
            `LDURH:  write_back <= {{(`WORD - 16){1'b0}}, read_data[15:0]};
            `LDURSW: write_back <= {{(`WORD - 32){1'b0}}, read_data[31:0]};
            default: begin
                case(mem_to_reg)
                    0: write_back <= alu_result;
                    1: write_back <= read_data;
                    2: write_back <= incremented_pc; 
                endcase
            end
        endcase
    end
    
endmodule
