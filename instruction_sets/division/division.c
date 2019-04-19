/* 
 * Psuedocode for the division program.
 *
 * Assume A refers to the address stored in X22
 */

void main() {
    long dividend = A[0], 
         divisor = A[1],
         quotient,
         remainer = dividend;

    while (remainer > 0) {
        remainer -= divisor;
        quotient++;
    }

    remainer += divisor;
    quotient--;

    A[2] = quotient;
    A[3] = remainer;
}