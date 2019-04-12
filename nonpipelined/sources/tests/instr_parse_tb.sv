`timescale 1ns / 1ps
`include "helpers.vh"
`include "constants.vh"

module instr_parse_tb;

    reg  [`INSTR_LEN-1:0] instruction;
    wire [4:0] rm, rn, rd;
    wire [8:0] address;
    wire [10:0] opcode;
    
    instr_parse UUT(.*);
    
    initial begin
        `TB_BEGIN
        
        // LDUR X9, [X10, #240]
        instruction = `INSTR_LEN'b11111000010011110000000101001001;
        #`CYCLE;
        
        // ADD X10, X21, X9
        instruction = `INSTR_LEN'b10001011000010010000001010101010;
        #`CYCLE;
        
        // STUR X9, [X10, #240]
        instruction = `INSTR_LEN'b11111000000011110000000101001001;
        #`CYCLE;
        
        `TB_END
    end

endmodule
