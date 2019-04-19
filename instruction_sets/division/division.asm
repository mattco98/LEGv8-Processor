// Load initial values
0:  LDUR X9,  [X22, #0]    // dividend
4:  LDUR X10, [X22, #8]    // divisor
8:  ADD  X11, XZR, XZR     // quotient
12: ADD  X12, X9,  XZR     // remainer

LOOP:
16: CMPI X12, XZR
20: B.LT #4
24: SUB  X12, X12, X10
28: ADDI X11, #1
32: B #-4

DONE:
36: ADD  X12, X12, X10
40: SUBI X11, #1
44: STUR X11, [X22, #16]
48: STUR X12, [X22, #24]