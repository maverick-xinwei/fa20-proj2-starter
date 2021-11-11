.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>



    #argc    : 5 
    #argv[1] : M0_PATH
    #argv[2] : M1_PATH
    #argv[3] : INPUT_PATH
    #argv[4] : OUTPUT_PATH

    # prologue
    addi sp, sp, -40
    sw ra, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)

	# =====================================
    # LOAD MATRICES
    # =====================================

    # check arguments number

    # a0(argc) == 5 
    li s1, 5
    bne a0, s1, incorrect_args_num


    lw s1, 4(a1)  # s1 : m0_path pointer
    lw s2, 8(a1)  # s2 : m1_path pointer
    lw s3, 12(a1) # s3 : input_path pointer
    lw s4, 16(a1) # s4 : output_path pointer

    # Load pretrained m0
    # a1(argv)

    li a0, 8 # 2 ints
    jal ra, malloc 
    beqz a0, malloc_fail
    mv s5, a0  # s5 stores rows and colums

    mv a0, s1
    mv a1, s5
    addi a2, s5, 4
    jal ra, read_matrix
    # m0_path is not needed anymore onward
    mv s1, a0   # s1 :  store m0 mem pointer

    # s1: m0 mem pointer
    # s5: 0(s5) rows  , 4(s5) cols


    # Load pretrained m1
    li a0, 8 # 2 ints
    jal ra, malloc 
    beqz a0, malloc_fail
    mv s6, a0  # s6 stores rows and colums

    mv a0, s2
    mv a1, s6
    addi a2, s6, 4
    jal ra, read_matrix
    # m1_path is not needed anymore onward
    mv s2, a0   # s2 :  store m1 mem pointer

    # s2: m1 mem pointer
    # s6: 0(s6) rows  , 4(s6) cols


    # Load input matrix
    li a0, 8 # 2 ints
    jal ra, malloc 
    beqz a0, malloc_fail
    mv s7, a0  # s7 stores rows and colums

    mv a0, s3
    mv a1, s7
    addi a2, s7, 4
    jal ra, read_matrix
    # input_path is not needed anymore onward
    mv s3, a0   # s3 :  store input mem pointer

    # s3: input mem pointer
    # s7: 0(s7) rows  , 4(s7) cols



    # s1: m0 mem pointer
    # s5: m0 0(s5) rows  , 4(s5) cols

    # s2: m1 mem pointer
    # s6: m1 0(s6) rows  , 4(s6) cols

    # s3: input mem pointer
    # s7: input mem 0(s7) rows  , 4(s7) cols

    # s4 : output_path pointer

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
      # allocate memory for output
      lw t0, 0(s5) # m0's rows
      lw t1, 4(s7) # input's cols
      mul a0, t0, t1
      mv s8, a0
      jal ra, malloc 
      beqz a0, malloc_fail
      mv s9, a0  # store hidden layer of m0*input

      mv a0, s1
      lw a1, 0(s5)
      lw a2, 4(s5)
      mv a3, s3
      lw a4, 0(s7)
      lw a5, 4(s7)
      mv a6, s9 
      jal ra, matmul


      # store the result's rows and cols into s5 
      lw t0, 4(s7)
      sw t0, 4(s5)


      #input is not needed, so can free mem pointed by s3, s7
      #m0 is not needed, so can free mem pointed by s1
      mv a0, s3
      jal ra, free
      mv a0, s7
      jal ra, free
      mv a0, s1
      jal ra, free




    # 2. NONLINEAR LAYER: ReLU(m0 * input)
      mv a0, s9
      mv a1, s8
      jal ra, relu

      # s9 : result of relu 
      # s5: rows and cols

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
      lw t0, 0(s6) # m1's rows
      lw t1, 4(s5) # input's cols
      mul a0, t0, t1
      mv s1, a0
      jal ra, malloc 
      beqz a0, malloc_fail
      mv s3, a0  # store hidden layer of m0*input


      mv a0, s2
      lw a1, 0(s6)
      lw a2, 4(s6)
      mv a3, s9
      lw a4, 0(s5)
      lw a5, 4(s5)
      mv a6, s3 
      jal ra, matmul

      lw t0, 0(s6)
      sw t0, 0(s5)

      # free m1 mems pointed by a2 and a6 since they are no longer needed
      mv a0, a6
      jal ra, free
      mv a0, a2
      jal ra, free

      # s3: mem pointer 
      # s5: rows and cols









    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

      mv a0, s4
      mv a1, s3
      lw a2, 0(s5)
      lw a3, 4(s5)
      jal ra, write_matrix




    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax




    # Print classification
    



    # Print newline afterwards for clarity


    # Epilogue
    sw ra, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw s7, 28(sp)
    sw s8, 32(sp)
    sw s9, 36(sp)
    addi sp, sp, 40

    ret

incorrect_args_num:
    li a1, 89
    jal exit2

malloc_fail:
    li a1, 88
    jal exit2
