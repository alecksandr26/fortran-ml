module mod_linear_regression
  use iso_fortran_env, only : real32, int32, real64
  use iso_c_binding
  use ieee_arithmetic, only: ieee_is_nan
  use assertf
  implicit none

  private
  public lr_init, lr_free, linear_regression, lr_train, lr_test

  type linear_regression
     integer(int32) :: n
     real(real32), pointer :: w(:)
  end type linear_regression
  
contains
  
  subroutine lr_init(lr, w)
    real(real32), intent(in) :: w(:)
    type(linear_regression), intent(out) :: lr

    ! Fetch the size from the array
    lr%n = size(w)

    allocate(lr%w(lr%n))
    
    ! Copy the initial weights 
    lr%w(:) = w(:)
  end subroutine lr_init

  subroutine lr_free(lr)
    type(linear_regression), intent(in out) :: lr
    deallocate(lr%w)
    lr%n = 0
  end subroutine lr_free

  subroutine lr_train(lr, inputs, outputs, lrate, nepochs)
    type(linear_regression), intent(in out) :: lr
    real(real32), intent(in) :: inputs(:, :), outputs(:)
    real(real32), intent(in) :: lrate
    integer(int32), intent(in) :: nepochs

    integer(int32) :: n, i, j, k
    real(real32), allocatable :: results(:), errors(:), delta(:)
    real(real32) :: err = 0

    n = size(outputs)
    allocate(results(n))
    allocate(errors(n))
    allocate(delta(n))
    
    do i = 1, nepochs
       do j = 1, n
          ! Vector multiplication w * x
          results(j) = 0
          do concurrent(k = 1 : lr%n)
             results(j) = results(j) + lr%w(k) * inputs(k, j)
          end do

          if (ieee_is_nan(results(j))) then
             print *, "Error: is NaN", i, results(j) ,inputs(:, j), lr%w, j
             call abort()
          else if (results(j) - 1 == results(j)) then ! Then infinite
             print *, "Error: is infinity", i, results(j), inputs(:, j), lr%w, j
             call abort()
          end if

          errors(j) = outputs(j) - results(j)
          if (abs(errors(j)) > err) then
             ! print *, "Not learning bruh ", abs(errors(j)), lr%w
          else
             ! print *, "Learning bruh ", abs(errors(j))
          end if
          err = abs(errors(j))
          
          delta(j) = lrate * errors(j)

          ! Update the weights
          do concurrent(k = 1 : lr%n)
             lr%w(k) = lr%w(k) + delta(j) * inputs(k, j)
          end do
       end do
    end do

    deallocate(results)
    deallocate(errors)
    deallocate(delta)
  end subroutine lr_train

  subroutine lr_test(lr, input, output)
    type(linear_regression), intent(in out) :: lr
    real(real32), intent(in) :: input(:)
    real(real32), intent(out) :: output
    integer(int32) k

    do concurrent(k = 1 : lr%n)
       output = output + lr%w(k) * input(k)
    end do
  end subroutine lr_test
  
end module mod_linear_regression
