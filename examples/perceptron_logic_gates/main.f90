
! Simple example to generate a simple file 
program example
    use iso_fortran_env, only : real32, int32
    use mod_perceptron
    use assertf

    type(perceptron) :: per
    real(real32) :: inputs(4,2), outputs(4), results(4), weigths(2)

    weigths = [0.8, 0.3]
    call p_init(per, weigths, - 0.2)      ! Initialize the perceptron

    inputs = reshape([0.0, 1.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0], [4,2])
    ! inputs = [[0.0, 1.0, 0.0, 1.0], [0.0, 0.0, 1.0, 1.0]]

    outputs = [- 1.0, - 1.0, - 1.0, 1.0] ! Outputs for the and logic gate

    ! Train the perceptron, with lrate = 0.1, nepochs = 1000
    call p_train(per, inputs, outputs, 0.1, 1000)

    ! Test the perceptron
    call p_test(per, inputs, results)

    ! Print all the data
    write(*,*) 'x1:', inputs(:, 1)
    write(*,*) 'x2:', inputs(:, 2)
    write(*,*) 'outputs:', outputs
    write(*,*) 'and_w1:', per%w(1)
    write(*,*) 'and_w2:', per%w(2)
    write(*,*) 'and_b:', per%b
    write(*,*) 'and_results:', results


    outputs = [-1.0, 1.0, 1.0, 1.0] ! Outputs for the  or logic gate

    ! Train the perceptron, with lrate = 0.1, nepochs = 1000
    call p_train(per, inputs, outputs, 0.1, 1000)

    ! Test the perceptron
    call p_test(per, inputs, results)

    write(*,*) 'or_w1:', per%w(1)
    write(*,*) 'or_w2:', per%w(2)
    write(*,*) 'or_b:', per%b
    write(*,*) 'or_results:', results

    outputs = [1.0, 1.0, 1.0, - 1.0] ! Outputs for the  or logic gate

    ! Train the perceptron, with lrate = 0.1, nepochs = 1000
    call p_train(per, inputs, outputs, 0.1, 1000)

    ! Test the perceptron
    call p_test(per, inputs, results)

    write(*,*) 'nand_w1:', per%w(1)
    write(*,*) 'nand_w2:', per%w(2)
    write(*,*) 'nand_b:', per%b
    write(*,*) 'nand_results:', results

    call p_free(per)
end program example
