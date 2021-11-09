.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp -24
    sw ra, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)

    mv s1, a1 # s1 pointer to matrix mem
    mv s2, a2 # s2 num of rows in matrix
    mv s3, a3 # s3 num of cols in matrix

    # calling fopen
    mv a1, a0
    li a2, 1 # write
    
    jal ra, fopen
    beqz a0, fopen_fail
    # s5 file handler
    mv s5, a0

    # fwrite cols and rows
    addi sp, sp, -8
    sw s2, 0(sp)
    sw s3, 4(sp)

    mv a1, s5
    mv a2, sp
    li a3, 2
    li a4, 4
    jal ra, fwrite
    li s4, 2 
    bne a0, s4, fwrite_fail  

    lw s2, 0(sp)
    lw s3, 4(sp)
    addi sp, sp, 8

    
    # calling fwrite
    mul s4, s2, s3
    mv a1, s5
    mv a2, s1
    mv a3, s4
    li a4, 4
    jal ra, fwrite
    bne a0, s4, fwrite_fail  

    # fclose
    mv a1, s5
    jal ra, fclose
    bne a0, zero, fclose_fail




    # Epilogue
    lw ra, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    addi sp, sp 24

    ret

fopen_fail:
    li  a1, 93 
    jal ra, exit2
fwrite_fail:
    li  a1, 94 
    jal ra, exit2
fclose_fail:
    li  a1, 95 
    jal ra, exit2
