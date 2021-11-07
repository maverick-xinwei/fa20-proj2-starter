.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    bge zero, a1, m0_arr_sz_err 
    bge zero, a2, m0_arr_sz_err 
    bge zero, a4, m1_arr_sz_err 
    bge zero, a5, m1_arr_sz_err 
    bne a2,   a4, m0_m1_match_err

    # Prologue
    addi sp, sp, -8
    sw s1, 4(sp)
    sw ra, 0(sp)


outer_loop_start:

    bge zero, a1, outer_loop_end 
    addi, a1, a1, -1

    mul  t0, a1, a2
    slli t0, t0, 2  # stride in byte
    add  s1, a0, t0  # a0 points to the row start

    mv t0, a5

inner_loop_start:
    bge zero, t0, outer_loop_start
    addi, t0, t0, -1


    addi sp, sp, -4
    sw t0, 0(sp)

    addi sp, sp, -28
    sw a0, 24(sp)
    sw a1, 20(sp)
    sw a2, 16(sp)
    sw a3, 12(sp)
    sw a4, 8(sp)
    sw a5, 4(sp)
    sw a6, 0(sp)


    # col start
    mv a0, s1
    slli a1, t0, 2
    add a1, a3, a1
    mv a2, a2 # redundant
    li a3, 1
    mv a4, a5

    # a0: arr0 row start addr
    # a1: arr1 col start addr
    # a2: size 
    # a3: arr0 stride
    # a4: arr1 stride
    jal ra dot

    # save returned a0 to t2
    mv t2, a0

    lw a0, 24(sp)
    lw a1, 20(sp)
    lw a2, 16(sp)
    lw a3, 12(sp)
    lw a4, 8(sp)
    lw a5, 4(sp)
    lw a6, 0(sp)
    addi sp, sp, 28

    lw t0, 0(sp)
    addi sp, sp, 4

    mul t1, a1, a5  # t1 = res_row_idx* res_col_num
    add t1, t1, t0  # t1 = t1 + res_col_idx
    slli t1, t1, 2  # t1 = t1 * 4   byte offset of result arrray
    add t1, a6, t1  # t1  result element addr 

    sw t2, 0(t1)
    j inner_loop_start


inner_loop_end:



outer_loop_end:

    # Epilogue
    lw s1, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 8
    
    
    ret

m0_arr_sz_err:
  li a0, 72
  jal exit
m1_arr_sz_err:
  li a0, 73
  jal exit
m0_m1_match_err:
  li a0, 74
  jal exit

