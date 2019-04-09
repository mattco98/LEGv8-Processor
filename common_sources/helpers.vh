`define assert(condition, messageIfFailed) \
    if (condition == 0) begin \
        $display("~~~ ASSERTION FAILED in %m: %s ~~~", messageIfFailed); \
    end else begin \
        $display("Assertion passed in %m"); \
    end 