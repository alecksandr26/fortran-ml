module mod_perceptron
    use iso_fortran_env, only : real32, int32
    implicit none

    private
    public p_init, p_train, p_test, perceptron

    ! The type where we are going to contain the weights and bieas
    type perceptron
        real(real32) :: w1, w2, b
    end type perceptron
    
contains
    ! threshold: A simple activation function
    pure function threshold(output)
        real(real32), intent(in) :: output
        real(real32) :: threshold
        if (output > 0.0) then
            threshold = 1.0
        else
            threshold = 0.0
        end if
    end function threshold
    
    ! p_init: Receives a perceptron type and adds to it the weights and bias
    subroutine p_init(per, w1, w2, b)
        real(real32), intent(in) :: w1, w2, b
        type(perceptron), intent(out) :: per
                
        
        per%w1 = w1
        per%w2 = w2
        per%b = b
    end subroutine p_init

    ! p_train: To train the perceptron with some data
    subroutine p_train(per, inputs, outputs, lrate, nepochs)
        type(perceptron), intent(inout) :: per ! inout Because we are going to modify
        ! The inputs and outputs to be trained
        real(real32), intent(in) :: inputs(:,:) ! Bindimensional array
        real(real32), intent(in) :: outputs(:), lrate ! Learning rate
        integer(int32), intent(in) :: nepochs        ! Num of epochs

        ! The size and the iterators
        integer(int32) :: n, i, j
        real(real32) :: output, error, delta
        
        n = size(inputs, 1)     ! Catch the amount of inputs, sizeof(inputs[1])
        
        do i = 1, nepochs            ! Start iterating
            do j = 1, n ! Concurrent iteration
                ! Computing the perceptron calculation
                output = per%b + per%w1 * inputs(j, 1) + per%w2 * inputs(j, 2)
                
                ! The threshold function
                output = threshold(output)

                ! Compute the error 
                error = outputs(j) - output
                delta = lrate * error

                ! Update the perceptron
                per%w1 = per%w1 + delta * inputs(j, 1)
                per%w2 = per%w2 + delta * inputs(j, 2)
                per%b = per%b + delta
            end do
        end do
    end subroutine p_train

    ! p_test: To test the perceptron with some inputs
    subroutine p_test(per, inputs, results)
        type(perceptron), intent(in) :: per
        real(real32), intent(in) :: inputs(:, :)
        real(real32), intent(out) :: results(:)

        ! The size and outputs
        integer(int32) :: n, i
        
        ! Test the perceptron
        n = size(inputs, 1)
        do concurrent(i = 1 : n)
            results(i) = per%b + per%w1 * inputs(i, 1) + per%w2 * inputs(i, 2)
            results(i) = threshold(results(i))
        end do
    end subroutine p_test
end module mod_perceptron
