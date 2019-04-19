# Instruction Sets

Contains difference instruction sets for testing various instructions, and to overall ensure the accuracy of the datapath.

### Sets

- division_unsigned
    - Divides two non-negative numbers (13 / 4). Assumes the dividend and divisor are stored in [X22, #0] and [X22, #8], respectively. Stores the quotient and remainder in [X22, #16] and [X22, #24], respectively.
- division_signed
    - Divides two possibly negative numbers (-13 / 4). Assumes the dividend and divisor are stored in [X22, #0] and [X22, #8], respectively. Stores the quotient and remainder in [X22, #16] and [X22, #24], respectively. 