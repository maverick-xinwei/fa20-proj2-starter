.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)


mv t3, zero # initialize t3 to be zero

loop_start:

  bge zero, a2, loop_end
  addi a2, a2, -1

  slli t0, a2, 2 # t0 : index*bytes
  mul t1, t0, a3 # t1 stride*index*bytes
  mul t2, t0, a4 # t2 stride*index*bytes
  add t1, t1, a0 # arr1
  add t2, t2, a1 # arr2
  lw  t1, 0(t1)
  lw  t2, 0(t2)

  mul t0, t1, t2
  add t3, t0, t3

  j loop_start

loop_end:
    mv a0, t3


    # Epilogue
    lw ra, 0(sp) 
    addi sp, sp, 4

    
    ret
