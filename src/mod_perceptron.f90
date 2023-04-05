#include <assertf.h>

module mod_perceptron
    use iso_fortran_env, only : real32, int32
 
    use assertf
    implicit none

    private
    public p_init, p_free, p_train, p_test, perceptron

    ! The type where we are going to contain the weights and bieas
    type perceptron
        real(real32) ::  b
        integer(int32) :: n     ! The amount of weights
        real(real32), pointer :: w(:) ! The weights
    end type perceptron
contains
    
    ! step: A simple activation function
    pure function step(output)
        real(real32), intent(in) :: output
        real(real32) :: step
        if (output > 0.0) then
            step = 1.0
        else
            step = 0.0
        end if
    end function step
    
    ! p_init: Receives a perceptron type and adds to it the weights and bias
    subroutine p_init(per, w, b)
        real(real32), intent(in) :: w(:), b
        type(perceptron), intent(out) :: per

        per%n = size(w)         ! Fetch the size of the array of weights
        
        ! Allocate the array of weights
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

        ! The size and the iterators
        integer(int32) :: n, i, j, k
        real(real32) :: output, error, delta
        
        n = size(inputs, 1)     ! Catch the amount of inputs, sizeof(inputs[1])
        
        do i = 1, nepochs            ! Start iterating
            do j = 1, n ! Concurrent iteration
                ! Computing the perceptron calculation
                output = per%b
                do concurrent(k = 1 : per%n)
                    output = output + per%w(k) * inputs(j, k)
                end do
                
                ! The step function
                output = step(output)

                ! Compute the error 
                error = outputs(j) - output
                delta = lrate * error

                ! Update the perceptron
                per%b = per%b + delta
                do concurrent(k = 1 : per%n)
                    per%w(k) = per%w(k) + delta * inputs(j, k)
                end do
            end do
        end do
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
            results(i) = step(results(i))
        end do
    end subroutine p_test
end module mod_perceptron
