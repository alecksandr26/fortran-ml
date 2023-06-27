#include <assertf.h>

module mod_perceptron
  use iso_fortran_env, only : real32, int32
  use assertf
  implicit none

  private
  public p_init, p_free, p_train, p_test, perceptron, p_get_weights

  ! The type where we are going to contain the weights and bieas
  type perceptron
     real(real32) ::  b
     integer(int32) :: n     ! The amount of weights
     real(real32), pointer :: w(:) ! The weights
  end type perceptron
contains

  ! sign_act: A simple activation function
  pure function sign_act(output)
    real(real32), intent(in) :: output
    real(real32) :: sign_act
    if (output > 0.0) then
       sign_act = 1.0
    else
       sign_act = - 1.0
    end if
  end function sign_act

  ! p_init: Receives a perceptron type and adds to it the weights and bias
  subroutine p_init(per, w, b)
    real(real32), intent(in) :: w(:), b
    type(perceptron), intent(out) :: per

    per%n = size(w)         ! Fetch the size of the array of weights

    ! Allocate the array of weights and copy it
    allocate(per%w(per%n))
    per%w(:) = w(:)
    per%b = b
  end subroutine p_init

  ! p_free: To free the perceptrons weights and set the size and bias to zero
  subroutine p_free(per)
    type(perceptron), intent(in out) :: per

    deallocate(per%w)
    per%n = 0
    per%b = 0
  end subroutine p_free

  ! p_train: To train the perceptron with some data
  subroutine p_train(per, inputs, outputs, lrate, nepochs)
    type(perceptron), intent(in out) :: per ! inout Because we are going to modify
    
    ! The inputs and outputs to be trained
    real(real32), intent(in) :: inputs(:,:) ! Bindimensional array
    real(real32), intent(in) :: outputs(:), lrate ! Learning rate
    integer(int32), intent(in) :: nepochs        ! Num of epochs
    real(real32), allocatable :: results(:), errors(:), deltas(:)

    ! The size and more arrays to catch the necessary data for the training
    integer(int32) :: n, i, j, k

    n = size(inputs, 1)     ! Catch the amount of inputs, sizeof(inputs[1])

    allocate(results(n))
    allocate(errors(n))
    allocate(deltas(n))

    do concurrent(i = 1 : nepochs)            ! Start iterating
       do concurrent(j = 1 : n) ! Concurrent iteration
          ! Computing the perceptron calculation
          results(j) = per%b
          do concurrent(k = 1 : per%n)
             results(j) = results(j) + per%w(k) * inputs(j, k)
          end do

          ! The activation function
          results(j) = sign_act(results(j))

          ! Compute the error 
          errors(j) = outputs(j) - results(j)
          deltas(j) = lrate * errors(j)

          ! Update the perceptron
          per%b = per%b + deltas(j)
          do concurrent(k = 1 : per%n)
             per%w(k) = per%w(k) + deltas(j) * inputs(j, k)
          end do
       end do
    end do

    deallocate(results)
    deallocate(errors)
    deallocate(deltas)
  end subroutine p_train

  ! p_test: To test the perceptron with some inputs
  subroutine p_test(per, inputs, results)
    type(perceptron), intent(in) :: per
    real(real32), intent(in) :: inputs(:, :)
    real(real32), intent(out) :: results(:)

    ! The size and outputs
    integer(int32) :: n, i, j

    ! Test the perceptron
    n = size(inputs, 1)
    do concurrent(i = 1 : n)
       results(i) = per%b
       do concurrent(j = 1 : per%n)
          results(i) = results(i) + per%w(j) * inputs(i, j)
       end do
       results(i) = sign_act(results(i))
    end do
  end subroutine p_test

  ! p_get_weights: To get the weights from the perceptron
  subroutine p_get_weights(per, weigths)
    type(perceptron), intent(in) :: per
    real(real32), intent(out) :: weigths(:)

    weigths(:) = per%w(:)
  end subroutine p_get_weights
end module mod_perceptron
