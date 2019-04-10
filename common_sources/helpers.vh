`define assert(to_test, value) \
    if (to_test != value) begin \
        $display("~~~ ASSERTION FAILED in %m => Expected: %d, Actual: %d ~~~", to_test, value); \
    end else begin \
        $display("Assertion passed in %m"); \
    end 