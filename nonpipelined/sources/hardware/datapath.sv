`timescale 1ns / 1ps
`include "constants.vh"


module datapath;

    // Clocks
    wire clk,
         instr_mem_clk,
         decode_read_clk,
         decode_write_clk,
         memory_clk;
         
    oscillator clk_gen(clk);
    delay #(1) instr_mem_clk_gen(clk, instr_mem_clk);
    delay #(2) read_clk_gen(clk, decode_read_clk);
    delay #(3) memory_clk_gen(clk, memory_clk);
    delay #(4) write_clk_gen(clk, decode_write_clk);
    
    // Fetch wires
    reg  reset;
    wire pc_src;
    wire [`INSTR_LEN-1:0] instruction;
    wire [`WORD-1:0] cur_pc;
    
    // Decode wires
    wire [`WORD-1:0] extended_instruction;
    wire [10:0] opcode;
    wire [`WORD-1:0] read_data1, read_data2;
    
    wire uncondbranch, branch, mem_read, mem_write, mem_to_reg, alu_src, reg_write;
    wire [1:0] alu_op;
    
    // Execute wires
    wire [`WORD-1:0] branch_alu_result, alu_result;
    wire zero;
    
    // Memory wires
    wire [`WORD-1:0] read_data;
    
    // Writeback wires
    wire [`WORD-1:0] write_back;
    
    Fetch FETCH(.*);
    Decode DECODE(.*);
    Execute EXECUTE(.*);
    Memory MEMORY(.*);
    Writeback WRITEBACK(.*);
    
    initial begin
        // Reset memory
        reset <= 1;
        #`CYCLE;
        
        // Continue running
        reset <= 0;
        #(`CYCLE * 20);
        
        $finish;
    end

endmodule
