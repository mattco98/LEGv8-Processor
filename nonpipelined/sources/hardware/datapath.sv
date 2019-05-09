`timescale 1ns / 1ps
`include "constants.vh"
`include "files.vh"


module datapath;
    parameter INSTRUCTION_FILE = `INSTRUCTION_FILE_DIVISION_SIGNED;
    parameter REG_FILE         = `REGISTER_FILE_DIVISION_SIGNED;
    parameter RAM_FILE         = `RAM_FILE_DIVISION_SIGNED;
    parameter CYCLES           = 100;

    // Clocks
    wire clk;
    wire clk_delayed_1;
    wire clk_delayed_2;
    wire clk_delayed_3;
    wire clk_delayed_4;
    wire clk_delayed_5;
    wire clk_delayed_6;
         
    oscillator clk_gen(clk);
    delay #(1) clk_delayed_1_gen(clk, clk_delayed_1);
    delay #(2) clk_delayed_2_gen(clk, clk_delayed_2);
    delay #(3) clk_delayed_3_gen(clk, clk_delayed_3);
    delay #(4) clk_delayed_4_gen(clk, clk_delayed_4);
    delay #(5) clk_delayed_5_gen(clk, clk_delayed_5);
    delay #(6) clk_delayed_6_gen(clk, clk_delayed_6);
    
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
    wire [1:0] mem_to_reg, mult_mode;
    wire [3:0] alu_op;
    
    // Execute wires
    wire [`WORD-1:0] branch_alu_result, alu_result;
    wire zero, negative, overflow, carry, multiplier_done;
    wire [31:0] sreg;
    
    // Memory wires
    wire [`WORD-1:0] read_data;
    
    // Writeback wires
    wire [`WORD-1:0] write_back;
    
    Fetch #(.PATH(INSTRUCTION_FILE)) Fetch(
        .clk(clk),
        .read_clk(clk_delayed_1), 
        .reset(reset),
        .pc_src(pc_src), 
        .branch_target(branch_alu_result),
        .alu_result(alu_result),
        .instruction(instruction),
        .pc(pc),
        .incremented_pc(incremented_pc)
    );
    
    Decode #(.PATH(REG_FILE)) Decode(
        .read_clk(clk_delayed_2),
        .write_clk(clk_delayed_6), 
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
        .mult_mode(mult_mode),
        .reg_write(reg_write),
        .update_sreg(update_sreg),
        .execute_result_loc(execute_result_loc),
        .mult_start(mult_start)
    );
    
    Execute Execute(
        .clk(clk_delayed_3),
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
        .multiplier_done(multiplier_done),
        .mult_mode(mult_mode)
    );
    
    Memory #(.PATH(RAM_FILE)) Memory(
        .read_clk(clk_delayed_4),
        .write_clk(clk_delayed_5),
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
    
    Writeback Writeback(
        .alu_result(alu_result),
        .read_data(read_data),
        .mem_to_reg(mem_to_reg),
        .instruction(instruction),
        .read_data2(read_data2),
        .incremented_pc(incremented_pc),
        .write_back(write_back)
    );
    
    initial begin
        // Reset memory
        reset <= 1;
        #6;
        
        // Continue running
        reset <= 0;
        #(`CYCLE * CYCLES);
        
        $finish;
    end

endmodule
