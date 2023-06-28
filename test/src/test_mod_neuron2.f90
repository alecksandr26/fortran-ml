program test_mod_neuron2
  use iso_fortran_env, only : real32, int32
  use mod_neuron
  implicit none

  type(neuron) :: ne
  real(real32) :: inputs(1, 7) = reshape([4, 5, 6, 7, 8, 9, 10], [1, 7])
  real(real32) :: outputs(7) = [50, 70, 72, 73, 90, 95, 105], output
  
  call n_init(ne, 1, PREDICT)

  call n_train(ne, inputs, outputs, 0.01, 1000000)

  print *, "MSE: ", mse(ne, inputs, outputs)

  output = 0.0
  print *, "Weights: ", ne%w
  
  call n_free(ne)
end program test_mod_neuron2

  
