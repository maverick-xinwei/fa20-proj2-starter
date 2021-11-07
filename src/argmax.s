.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)



li t2, 1 # a flag indicating the first loop

loop_start:
  bge zero, a1, loop_end 
  addi a1, a1, -1
  slli t0, a1, 2
  add t0, t0, a0
  lw t1, 0(t0) ## t1 = a0[idx]

  bnez t2,  set_flag # only for first loop

  # branch if t1 < t3 (prev elem)
  blt t1, t3, loop_continue

  mv t4, a1 # store the index of a larger element

  mv t3, t1 # t3 prev

  j loop_continue
  

set_flag:
  mv t4, a1
  mv t2, zero
  mv t3, t1 # t3 prev


loop_continue:
  j loop_start


loop_end:
    
    mv a0, t4

    # Epilogue
    sw ra, 0(sp)
    addi sp, sp, 4


    ret
