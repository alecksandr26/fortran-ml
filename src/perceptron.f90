module perceptron_mod
    use iso_fortran_env, only : real32, int32
    implicit none

    private
    public p_init, 

    ! The type where we are going to contain the weights and bieas
    type perceptron
        real(real32) :: w1, w2, b
    end type perceptron
    
contains
    ! p_init: Receives a perceptron type and adds to it the weights and bias
    subroutine p_init(per, w1, w2, b)
        type(perceptron), intent(out) :: per
        real(real32), intent(in) :: w1, w2, b
        
        per%w1 = w1
        per%w2 = w2
        per%b = b
    end subroutine p_init

    ! p_train: To train the perceptron with some data
    subroutine p_train(per, inputs, outputs, lrate, nepochs)
        type(perceptron), intent(in) :: per
        ! The inputs and outputs to be trained
        real(real32), intent(in) :: inptus(:,:) ! Bindimensional array
        real(real32), intent(in) :: outpus(:), lrate ! Learning rate
        integer(int32), intent(in) :: nepochs        ! Num of epochs

        ! The size and the iterators
        integer(int32) :: n, i, j
        real(real32) :: output, error, delta
        
        n = size(inptus, 1)     ! Catch the amount of inputs
        do concurrent(i = 1 : n) ! Concurrent iteration
            
        end do
    end subroutine p_train
end module perceptron_mod
