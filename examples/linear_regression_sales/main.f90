program example
  use iso_fortran_env, only : real32, int32
  use mod_linear_regression
  use assertf
  implicit none

  type(linear_regression) :: lr
  real(real32) :: inputs(2, 7) = reshape([1, 4, 1, 5, 1, 6, 1, 7, 1, 8, 1, 9, 1, 10], [2, 7])
  ! inputs = [[1, 4], [1, 5], [1, 6], [1, 7], [1, 8], [1, 9], [1, 10]]
  real(real32) :: outputs(7) = [50, 70, 72, 73, 90, 95, 105]
  real(real32) :: output = 0.0
  integer(int32) :: i = 0

  write(*, '(A)', advance='no') "inputs: "
  do i = 1, size(inputs, 2)
     write(*, '(F0.1, A)', advance='no') inputs(2, i), ' '
  end do
  write(*,*)

  write(*, '(A)', advance='no') "outputs: "
  do i = 1, size(outputs)
     write(*, '(F0.1, A)', advance='no') outputs(i), ' '
  end do
  write(*,*)
  

  call lr_init(lr, [0.0, 0.0])
  call lr_train(lr, inputs, outputs, 0.01, 100)

  write(*, '(A)', advance='no') "results: "
  do i = 1, size(inputs, 2)
     call lr_test(lr, inputs(:, i), output)
     write(*, '(F0.1, A)', advance='no') output, ' '
     output = 0.0
  end do
  write(*,*)

  write(*, '(A)', advance='no') "weights: "
  write(*, '(F0.1, A, F0.1)', advance='no') lr%w(1), ' ', lr%w(2)
  write(*,*)
  
  call lr_free(lr)
end program example
  
