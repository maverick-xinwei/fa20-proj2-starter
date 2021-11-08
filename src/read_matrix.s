.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp, sp, -20
    sw ra, 16(sp) 
    sw s4, 12(sp) 
    sw s3, 8(sp) 
    sw s2, 4(sp) 
    sw s1, 0(sp) 
	

    # Calling fopen
    mv a1, a0     # fopen's a1=filepath
    mv a2, zero   # fopen's a2 = 0 ("r")
    jal ra,fopen         # return file descriptor in a0
    mv s1, a0     # save a0 to s1
    beqz a0, fopen_fail



    # malloc to allocate 2 int (2*4 bytes)
    li a0, 8 
    jal ra, malloc
    beqz a0, malloc_fail

    # Calling fread
    mv s2, a0
    mv a1, s1     # fread a1 = file descriptor
    mv a2, s2     # a2: allocated buffer
    li a3, 8      # a3: number of bytes to read
    jal ra,fread
    li a3, 8
    bne a0, a3, fread_fail

    #  num of rows
    lw t0, 0(s2)
    #  num of cols
    lw t1, 4(s2)

    # num of bytes in matrix
    mul s3, t0, t1

    # malloc number of bytes rows*cols 
    mv a0, s3 
    jal ra, malloc 
    beqz a0, malloc_fail

    # fread 
    mv s4, a0
    mv a1, s1
    mv a2, s4
    mv a3, s3
    jal ra, fread
    bne a0, s3, fread_fail

    mv a0, s4
    lw a1, 0(s2) 
    lw a2, 4(s2) 

    # Epilogue
    lw ra, 16(sp) 
    lw s4, 12(sp) 
    lw s3, 8(sp) 
    lw s2, 4(sp) 
    lw s1, 0(sp) 
    addi sp, sp, 20


    ret


malloc_fail:
    li a1, 88
    jal ra, exit2

fopen_fail:
    li a1, 90
    jal ra, exit2

fread_fail:
    li a1, 91
    jal ra, exit2

fclose_fail:
    li a1, 92
    jal ra, exit2
