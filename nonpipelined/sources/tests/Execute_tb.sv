`timescale 1ns / 1ps
`include "constants.vh"

module Execute_tb;

    //Inputs
    reg [`WORD-1:0] pc;
    reg [`WORD-1:0] sign_extended_instr;
    reg [`WORD-1:0] read_data1;
    reg [`WORD-1:0] read_data2;
    reg [10:0] opcode;
    reg [1:0] alu_op;
    reg alu_src;
    
    //Outputs
    wire [`WORD-1:0] branch_alu_result;
    wire zero;
    wire [`WORD-1:0] alu_result;
    
    Execute EXECUTE(.*);
                     
    initial begin
        pc <= 'd200;
        sign_extended_instr <= 'h00000040;
        read_data1 <= 'd16;
        read_data2 <= 'd0;
        opcode <= 'b11111000010;
        alu_op <= 'd0;
        alu_src <= 'b1;
        #`CYCLE;
        
        pc <= 'd204;
        sign_extended_instr <= 'h8B09026A;
        read_data1 <= 'd10;
        read_data2 <= 'd20;
        opcode <= 'b10001011000;
        alu_op <= 'd2;
        alu_src <= 'b0;
        #`CYCLE;
        
        pc <= 'd208;
        sign_extended_instr <= 'hCB0A028B;
        read_data1 <= 'd30;
        read_data2 <= 'd30;
        opcode <= 'b11001011000;
        alu_op <= 'd2;
        alu_src <= 'b0;
        #`CYCLE;
        
        pc <= 'd212;
        sign_extended_instr <= 'h00000060;
        read_data1 <= 'd16;
        read_data2 <= 'd0;
        opcode <= 'b11111000000;
        alu_op <= 'd0;
        alu_src <= 'b1;
        #`CYCLE;
        
        pc <= 'd216;
        sign_extended_instr <= 'hFFFFFFFFFFFFFFFB;
        read_data1 <= 'd0;
        read_data2 <= 'd0;
        opcode <= 'b10110100;
        alu_op <= 'd1;
        alu_src <= 'b0;
        #`CYCLE;
        
        pc <= 'd196;
        sign_extended_instr <= 'h00000008;
        read_data1 <= 0;
        read_data2 <= 20;
        opcode <= 'b10110100;
        alu_op <= 'd1;
        alu_src <= 'b0;
        #`CYCLE;
        
        pc <= 'd228;
        sign_extended_instr <= 'h00000040;
        read_data1 <= 0;
        read_data2 <= 0;
        opcode <= 'b000101;
        alu_op <= 'd0;
        alu_src <= 'b0;
        #`CYCLE;
        
        pc <= 'd484;
        sign_extended_instr <= 'hFFFFFFFFFFFFFFC9;
        read_data1 <= 0;
        read_data2 <= 0;
        opcode <= 'b000101;
        alu_op <= 'd0;
        alu_src <= 'b0;
        #`CYCLE;
        
        pc <= 'd264;
        sign_extended_instr <= 'hAA150149;
        read_data1 <= 'd30;
        read_data2 <= 'd0;
        opcode <= 'b10101010000;
        alu_op <= 'd2;
        alu_src <= 'b0;
        #`CYCLE;
        
        pc <= 'd268;
        sign_extended_instr <= 'h8A0A02C9;
        read_data1 <= 'd16;
        read_data2 <= 'd30;
        opcode <= 'b10001010000;
        alu_op <= 'd2;
        alu_src <='b0;
        #`CYCLE;
        
        $finish;
end 

endmodule
