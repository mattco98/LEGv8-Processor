`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"

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
    wire [`WORD-1:0] pc;
    
    // Decode wires
    wire [`WORD-1:0] extended_instruction;
    wire [10:0] opcode;
    wire [`WORD-1:0] read_data1, read_data2;
    
    wire unconditional_branch, branch, mem_read, mem_write, mem_to_reg, alu_src, reg_write;
    wire [1:0] alu_op;
    
    // Execute wires
    wire [`WORD-1:0] branch_alu_result, alu_result;
    wire zero;
    
    // Memory wires
    wire [`WORD-1:0] read_data;
    
    // Writeback wires
    wire [`WORD-1:0] write_back;
    
    Fetch #(`INSTRUCTION_FILE_DIVISION) FETCH(
        .clk(clk),
        .instr_mem_clk(instr_mem_clk), 
        .reset(reset),
        .pc_src(pc_src), 
        .branch_target(branch_alu_result),
        .instruction(instruction),
        .pc(pc)
    );
    
    Decode #(`RAM_FILE_DIVISION) DECODE(
        .read_clk(decode_read_clk),
        .write_clk(decode_write_clk), 
        .instruction(instruction), 
        .write_data(write_back),
        .extended_instruction(extended_instruction),
        .opcode(opcode),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .unconditional_branch(unconditional_branch),
        .branch(branch),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .alu_op(alu_op),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write)
    );
    
    Execute EXECUTE(
        .pc(pc),
        .sign_extended_instr(extended_instruction),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .opcode(opcode),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .branch_alu_result(branch_alu_result),
        .zero(zero),
        .alu_result(alu_result)
    );
    
    Memory MEMORY(
        .read_clk(memory_clk),
        .write_clk(memory_clk),
        .uncondbranch(uncondbranch),
        .branch(branch),
        .zero(zero),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(alu_result),
        .write_data(read_data2),
        .read_data(read_data),
        .pc_src(pc_src)
    );
    
    Writeback WRITEBACK(
        .alu_result(alu_result),
        .read_data(read_data),
        .mem_to_reg(mem_to_reg),
        .write_back(write_back)
    );
    
    initial begin
        // Reset memory
        reset <= 1;
        #`CYCLE;
        
        // Continue running
        reset <= 0;
        #(`CYCLE * 50);
        
        $finish;
    end

endmodule
