# Instruction Sets

Contains difference instruction sets for testing various instructions, and to overall ensure the accuracy of the datapath.

### Sets

- division
    - Divides two numbers. Assumes the dividend and divisor are stored in [X22, #0] and [X22, #8], respectively. Stores the quotient and remainer in [X22, #16] and [X22, #24], respectively