`define TB_BEGIN() \
    $display("=== BEGIN TEST BENCH %m ===");
    
`define TB_END() \
    $display("=== END TEST BENCH ===");
    
`define EXTEND(src, by) \
    {{by{src}}, src}
    