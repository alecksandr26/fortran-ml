
program test_mod_neuron
  use iso_fortran_env, only : real32, int32
  use mod_neuron
  implicit none

  type(neuron) :: ne
  ! logic gate and
  real(real32) :: inputs(4, 2) = reshape([0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 0.0, 1.0], [4, 2])
  ! [[0, 0], [1, 0], [0, 1], [1, 1]]
  real(real32) :: outputs(4) = [0.0, 0.0, 0.0, 1.0], output

  ! logic gate or
  ! real(real32) :: inputs(4, 2) = reshape([0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 0.0, 1.0], [4, 2])
  ! [[0, 0], [1, 0], [0, 1], [1, 1]]
  ! real(real32) :: outputs(4) = [0.0, 1.0, 1.0, 1.0], output

  ! logic gate nand
  ! real(real32) :: inputs(4, 2) = reshape([0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 0.0, 1.0], [4, 2])
  ! [[0, 0], [1, 0], [0, 1], [1, 1]]
  ! real(real32) :: outputs(4) = [1.0, 1.0, 1.0, 0.0], output

  ! ! logic gate xor, need more neurons
  ! real(real32) :: inputs(4, 2) = reshape([0.0, 0.0, 1.0, 1.0, 0.0, 1.0, 0.0, 1.0], [4, 2])
  ! ! [[0, 0], [1, 0], [0, 1], [1, 1]]
  ! real(real32) :: outputs(4) = [0.0, 1.0, 1.0, 0.0], output
  
  call n_init(ne, 2, CLASSIFICATION)

  call n_train(ne, inputs, outputs, 0.1, 100000)

  write(*, '(A, F8.6)') "MSE: ", mse(ne, inputs, outputs)

  output = 0.0
  call n_test(ne, [1.0, 1.0], output)
  write(*, '(A, F8.6)') "1, 1: ", output
  
  call n_test(ne, [0.0, 1.0], output)
  write(*, '(A, F8.6)') "0, 1: ", output
  
  call n_test(ne, [1.0, 0.0], output)
  write(*, '(A, F8.6)') "1, 0: ", output
  
  call n_test(ne, [0.0, 0.0], output)
  write(*, '(A, F8.6)') "0, 0: ", output
  
  print *, "Weights: ", ne%w
  
  call n_free(ne)
end program test_mod_neuron
