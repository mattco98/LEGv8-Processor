`timescale 1ns / 1ps
`include "constants.vh"
`include "helpers.vh"

module control_tb;

    reg  [`INSTR_LEN-1:0] instruction;
    wire [10:0] opcode;
    wire readreg2_control, alu_src, mem_read, mem_write, mem_to_reg, reg_write, branch, unconditional_branch;
    wire [1:0] alu_op;
    wire [10:0] combined_signals;
    
    assign combined_signals = {readreg2_control, alu_src, mem_read, 
    mem_write, mem_to_reg, reg_write, branch, unconditional_branch, alu_op};
    
    control UUT(.*);  
    
    assign opcode = instruction[31:21];
    
    initial begin
        `TB_BEGIN
        
        // LDUR X9, [X22, #64]
        instruction <= 32'hF84402C9;
        #(`CYCLE / 2) assert(combined_signals == 10'b0110110000) else $error("[0] combined_signals: %b", combined_signals);
        #(`CYCLE / 2);
        
        // ADD X10, X19, X9
        instruction <= 32'h8B09026A;
        #(`CYCLE / 2) assert(combined_signals == 10'b0000010010) else $error("[1] combined_signals: %b", combined_signals);
        #(`CYCLE / 2);
        
        // SUB X11, X20, X10
        instruction <= 32'hCB0A028B;
        #(`CYCLE / 2) assert(combined_signals == 10'b0000010010) else $error("[2] combined_signals: %b", combined_signals);
        #(`CYCLE / 2);
        
        // STUR X11, [X22, #96]
        instruction <= 32'hF80602CB;
        #(`CYCLE / 2) assert(combined_signals == 10'b1101000000) else $error("[3]combined_signals: %b", combined_signals);
        #(`CYCLE / 2);
        
        // CBZ X11, -5
        instruction <= 32'hB4FFFF6B;
        #(`CYCLE / 2) assert(combined_signals == 10'b1000001001) else $error("[4] combined_signals: %b", combined_signals);
        #(`CYCLE / 2);
        
        // CBZ X9, 8
        instruction <= 32'hB4000109;
        #(`CYCLE / 2) assert(combined_signals == 10'b1000001001) else $error("[5] combined_signals: %b", combined_signals);
        #(`CYCLE / 2);
        
        // B 64
        instruction <= 32'h14000040;
        #(`CYCLE / 2) assert(combined_signals == 10'b0000001001) else $error("[6] combined_signals: %b", combined_signals);
        #(`CYCLE / 2);
        
        // B -55
        instruction <= 32'h17FFFFC9;
        #(`CYCLE / 2) assert(combined_signals == 10'b0000001001) else $error("[7] combined_signals: %b", combined_signals);
        #(`CYCLE / 2);
        
        // ORR X9, X10, X21
        instruction <= 32'hAA150149;
        #(`CYCLE / 2) assert(combined_signals == 10'b0000010010) else $error("[8] combined_signals: %b", combined_signals);
        #(`CYCLE / 2);
        
        // AND X9, X22, X10
        instruction <= 32'h8A0A02C9;
        #(`CYCLE / 2) assert(combined_signals == 10'b0000010010) else $error("[9] combined_signals: %b", combined_signals);
        #(`CYCLE / 2);
        
        `TB_END
        
        $finish;
    end

endmodule
