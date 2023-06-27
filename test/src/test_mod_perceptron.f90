! Include the assertions
#include <assertf.h>

program test_mod_perceptron
  use iso_fortran_env, only : real32, int32
  use mod_perceptron
  use assertf
  implicit none

  ! Intialize the object 
  type(perceptron) :: per

  ! Execute all the tests
  call test_and_gate(per)
  call test_or_gate(per)
  call test_nand_gate(per)

contains
  ! test_and_gate: To testa the perceptron for the logic gate and
  subroutine test_and_gate(per)
    type(perceptron), intent(in out) :: per
    real(real32) :: inputs(4,2), outputs(4), results(4), weigths(2)

    weigths = [0.2, 0.9]    ! The random assign weights

    call p_init(per, weigths, - 0.2)      ! Initialize the perceptron

    inputs = reshape([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0], [4,2])
    ! inputs = [[0.0, 0.0, 0.0, 1.0], [1.0, 0.0, 1.0, 1.0]]

    outputs = [-1.0, -1.0, -1.0, 1.0] ! Outputs for the and logic gate

    ! Train the perceptron, with lrate = 0.1, nepochs = 1000
    call p_train(per, inputs, outputs, 0.1, 1000)

    ! Test the perceptron
    call p_test(per, inputs, results)

    ! Compare the results into an asserts
    assert(all(results == outputs)) ! Compare
    

    call p_free(per)        ! Free the perceptron
  end subroutine test_and_gate

  ! test_or_gate: Testing the perceptron for the logic gate or
  subroutine test_or_gate(per)
    type(perceptron), intent(inout) :: per
    real(real32) :: inputs(4,2), outputs(4), results(4), weigths(2)

    weigths = [0.5, 0.5]    ! The random assign weights

    call p_init(per, weigths, - 0.7)      ! Initialize the perceptron with a random inputs

    inputs = reshape([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0], [4,2])
    ! inputs = [[0.0, 0.0, 0.0, 1.0], [1.0, 0.0, 1.0, 1.0]]

    outputs = [1.0, -1.0, 1.0, 1.0] ! Outputs for the or logic gate

    ! Train the perceptron, with lrate = 0.1, nepochs = 1000
    call p_train(per, inputs, outputs, 0.1, 1000)

    ! Test the perceptron
    call p_test(per, inputs, results)

    ! Compare the results into an asserts
    assert(all(results == outputs)) !Testing the and gate

    call p_free(per)        ! Free the perceptron
  end subroutine test_or_gate

  ! test_nand_gate: Testing the perceptron for the logic gate nand
  subroutine test_nand_gate(per)
    type(perceptron), intent(inout) :: per
    real(real32) :: inputs(4,2), outputs(4), results(4), weigths(2)

    weigths = [0.1, 0.2]    ! The random assign weights

    call p_init(per, weigths, - 0.3)      ! Initialize the perceptron with a random inputs

    inputs = reshape([0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 1.0], [4,2])
    ! inputs = [[0.0, 0.0, 0.0, 1.0], [1.0, 0.0, 1.0, 1.0]]

    outputs = [1.0, 1.0, 1.0, -1.0] ! Outputs for the or logic gate

    ! Train the perceptron, with lrate = 0.1, nepochs = 1000
    call p_train(per, inputs, outputs, 0.1, 1000)

    ! Test the perceptron
    call p_test(per, inputs, results)

    ! Compare the results into an asserts
    assert(all(results == outputs)) !Testing the and gate

    call p_free(per)        ! Free the perceptron
  end subroutine test_nand_gate
end program test_mod_perceptron




