`timescale 1ns / 1ps
`include "helpers.vh"
`include "constants.vh"

module sign_extender_tb;

    wire clk;
    reg  [`INSTR_LEN-1:0] instruction;
    wire [`INSTR_LEN-1:0] out;
    
    oscillator clk_gen(clk);
    
    sign_extender UUT(.*);
    
    initial begin
        `TB_BEGIN
        
        // LDUR X9, [X22, #64]
        instruction <= 32'hF84402C9;
        #`CYCLE assert(out == `WORD'd64) else $error("[0] out != `WORD'd64");
        
        // ADD X10, X19, X9
        instruction <= 32'h8B09026A;
        #`CYCLE assert(out == instruction) else $error("[1] out != instruction");
        
        // SUB X11, X20, X10
        instruction <= 32'hCB0A028B;
        #`CYCLE assert(out == instruction) else $error("[2] out != instruction");
        
        // STUR X11, [X22, #96]
        instruction <= 32'hF80602CB;
        #`CYCLE assert(out == 96) else $error("[3] out != 96");
        
        // CBZ X11, -5
        instruction <= 32'hB4FFFF6B;
        #`CYCLE assert(out == -5) else $error("[4] out != -5");
        
        // CBZ X9, 8
        instruction <= 32'hB4000109;
        #`CYCLE assert(out == 8) else $error("[5] out != 8");
        
        // B 64
        instruction <= 32'h14000040;
        #`CYCLE assert(out == 64) else $error("[6] out != 64");
        
        // B -55
        instruction <= 32'h17FFFFC9;
        #`CYCLE assert(out == -55) else $error("[7] out != -55");
        
        // ORR X9, X10, X21
        instruction <= 32'hAA150149;
        #`CYCLE assert(out == instruction) else $error("[8] out != instruction");;
        
        // AND X9, X22, X10
        instruction <= 32'h8A0A02C9;
        #`CYCLE assert(out == instruction) else $error("[9] out != instruction");
        
        `TB_END
        $finish;
    end

endmodule
