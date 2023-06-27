program test_mod_linear_regression
  use iso_fortran_env, only : real32, int32
  use assertf
  use mod_linear_regression
  implicit none

  type(linear_regression) :: lr
  real(real32) :: inputs(2, 7) = reshape([1, 4, 1, 5, 1, 6, 1, 7, 1, 8, 1, 9, 1, 10], [2, 7])
  real(real32) :: outputs(7) = [50, 70, 72, 73, 90, 95, 105]
  real(real32) :: output = 0.0
  
  call lr_init(lr, [0.0, 0.0])
  call lr_train(lr, inputs, outputs, 0.0001, 4000000)
  call lr_test(lr, [1.0, 10.0], output)
  
  print *, output
  
  call lr_free(lr)
end program test_mod_linear_regression

  


  
