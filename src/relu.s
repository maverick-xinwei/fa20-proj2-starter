.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)



loop_start:

  bge zero, a1, loop_end
  addi a1, a1, -1

  slli t0, a1, 2 # t0 = index *4               multiple the index by 4 to get the address offset
  add t1, a0, t0 # t1 = start_addr + index*4   addr of elem   calc the addr of the src element
  lw t2, 0(t1)      # load the element to register

  bge t2, zero, loop_continue # if elem >= 0, then does nothing but continue with the loop

  sw zero, 0(t1)


loop_continue:
  j loop_start


loop_end:

    # Epilogue
    lw ra, 0(sp)
    addi, sp, sp, 4

    
	ret
