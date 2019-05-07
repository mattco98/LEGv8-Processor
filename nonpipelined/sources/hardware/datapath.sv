`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"

module datapath;
    parameter INSTRUCTION_FILE = `INSTRUCTION_FILE_MULTIPLICATION;
    parameter REG_FILE = `REGISTER_FILE_FUNCTIONS;
    parameter RAM_FILE = `RAM_FILE_FUNCTIONS;

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
    wire [1:0] pc_src;
    wire [`INSTR_LEN-1:0] instruction;
    wire [`WORD-1:0] pc, incremented_pc;
    
    // Decode wires
    wire [`WORD-1:0] extended_instruction;
    wire [10:0] opcode;
    wire [`WORD-1:0] read_data1, read_data2;
    
    wire mem_read, mem_write, alu_src, reg_write, update_sreg, stall, execute_result_loc, mult_start;
    wire [2:0] branch_op;
    wire [1:0] mem_to_reg;
    wire [3:0] alu_op;
    
    // Execute wires
    wire [`WORD-1:0] branch_alu_result, alu_result;
    wire zero, negative, overflow, carry, multiplier_done;
    wire [31:0] sreg;
    
    // Memory wires
    wire [`WORD-1:0] read_data;
    
    // Writeback wires
    wire [`WORD-1:0] write_back;
    
    Fetch #(INSTRUCTION_FILE) FETCH(
        .clk(clk),
        .instr_mem_clk(instr_mem_clk), 
        .reset(reset),
        .pc_src(pc_src), 
        .branch_target(branch_alu_result),
        .alu_result(alu_result),
        .instruction(instruction),
        .pc(pc),
        .incremented_pc(incremented_pc)
    );
    
    Decode #(REG_FILE) DECODE(
        .read_clk(decode_read_clk),
        .write_clk(decode_write_clk), 
        .reset(reset),
        .stall(stall),
        .multiplier_done(multiplier_done),
        .instruction(instruction), 
        .write_data(write_back),
        .extended_instruction(extended_instruction),
        .opcode(opcode),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .alu_op(alu_op),
        .branch_op(branch_op),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .reg_write(reg_write),
        .update_sreg(update_sreg),
        .execute_result_loc(execute_result_loc),
        .mult_start(mult_start)
    );
    
    Execute EXECUTE(
        .clk(memory_clk), // TODO: Rename clk signals
        .reset(reset),
        .pc(pc),
        .sign_extended_instr(extended_instruction),
        .read_data1(read_data1),
        .read_data2(read_data2),
        .opcode(opcode),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .branch_alu_result(branch_alu_result),
        .zero(zero),
        .overflow(overflow),
        .carry(carry),
        .negative(negative),
        .alu_result(alu_result),
        .update_sreg(update_sreg),
        .execute_result_loc(execute_result_loc),
        .mult_start(mult_start),
        .stall(stall),
        .multiplier_done(multiplier_done)
    );
    
    Memory #(RAM_FILE) MEMORY(
        .read_clk(memory_clk),
        .write_clk(memory_clk),
        .reset(reset),
        .opcode(opcode),
        .rt(instruction[4:0]),
        .branch_op(branch_op),
        .zero(zero),
        .negative(negative),
        .carry(carry),
        .overflow(overflow),
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
        .opcode(opcode),
        .incremented_pc(incremented_pc),
        .write_back(write_back)
    );
    
    initial begin
        // Reset memory
        reset <= 1;
        #6;
        
        // Continue running
        reset <= 0;
        #(`CYCLE * 70);
        
        $finish;
    end

endmodule
