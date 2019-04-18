`timescale 1ns / 1ps
`include "constants.vh"
`include "helpers.vh"


module alu_tb;

    reg [`WORD-1:0] a, b;
    reg [3:0] alu_control;
    wire [`WORD-1:0] result;
    wire zero, negative, carry, overflow;
    
    alu ALU(.*);
    
    initial begin
        `TB_BEGIN
        
        a <= 64'h7FFFFFFFFFFFFFFF;
        b <= 64'h0000000000000001;
        alu_control <= `ALU_ADD;
        #`CYCLE; 
        assert(overflow == 1) else $error("[0] overflow == 0");
        assert(negative == 1) else $error("[1] negative == 0");
        assert(zero == 0) else $error("[2] zero == 1");
        
        a <= 64'h7FFFFFFFFFFFFFFE;
        b <= 64'h0000000000000001;
        alu_control <= `ALU_ADD;
        #`CYCLE; 
        assert(overflow == 0) else $error("[3] overflow == 1");
        assert(negative == 0) else $error("[4] negative == 1");
        assert(zero == 0) else $error("[5] zero == 1"); 
        
        a <= 64'h8000000000000000;
        b <= 64'h0000000000000001;
        alu_control <= `ALU_SUBTRACT;
        #`CYCLE; 
        assert(overflow == 1) else $error("[6] overflow == 0");
        assert(negative == 0) else $error("[7] negative == 1");
        assert(zero == 0) else $error("[8] zero == 1");
        
        a <= 64'h8000000000000000;
        b <= 64'hFFFFFFFFFFFFFFFF;
        alu_control <= `ALU_SUBTRACT;
        #`CYCLE;
        assert(overflow == 0) else $error("[9] overflow == 1");
        assert(negative == 1) else $error("[10] negative == 0");
        assert(zero == 0) else $error("[11] zero == 1");
        
        a <= 64'hFFFFFFFFFFFFFFFD;
        b <= 64'h0000000000000003;
        alu_control <= `ALU_ADD;
        #`CYCLE;
        assert(overflow == 0) else $error("[12] overflow == 1");
        assert(negative == 0) else $error("[13] negative == 1");
        assert(zero == 1) else $error("[14] zero == 0");
        
        `TB_END
        $finish;
    end

endmodule
