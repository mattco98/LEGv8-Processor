`timescale 1ns / 1ps
`include "constants.vh"


module Writeback(
    input      [`WORD-1:0]      alu_result,
    input      [`WORD-1:0]      read_data,
    input      [`WORD-1:0]      incremented_pc,
    input      [`WORD-1:0]      read_data2,
    input      [1:0]            mem_to_reg,
    input      [`INSTR_LEN-1:0] instruction,
    output reg [`WORD-1:0]      write_back
);

    wire [10:0] opcode    = instruction[31:21];
    wire [6:0]  mov_shift = instruction[22:21] << 4;

    always @* begin
        casez(opcode)
            `LDURB:  write_back <= {{(`WORD -  8){1'b0}}, read_data[7:0]};
            `LDURH:  write_back <= {{(`WORD - 16){1'b0}}, read_data[15:0]};
            `LDURSW: write_back <= {{(`WORD - 32){1'b0}}, read_data[31:0]};
            `MOVZ:   write_back <= (instruction[20:5] << mov_shift);
            `MOVK: 
                case(mov_shift)
                    0:  write_back <= {read_data2[16+:48], instruction[20:5]};
                    16: write_back <= {read_data2[32+:32], instruction[20:5], read_data2[0+:16]};
                    32: write_back <= {read_data2[48+:16], instruction[20:5], read_data2[0+:32]};
                    48: write_back <= {instruction[20:5],  read_data2[0+:48]}; 
                endcase
            default: 
                case(mem_to_reg)
                    0: write_back <= alu_result;
                    1: write_back <= read_data;
                    2: write_back <= incremented_pc; 
                endcase
        endcase
    end
    
endmodule
