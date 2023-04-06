#include <assertf.h>

#define WIDTH 20
#define HEIGHT 20
#define CHECK_SEED 420
#define SAMPLE_SIZE 75

! TODO: Find data for circles and rectangles

program p_rectangle_circle 
    use iso_fortran_env, only: real32, int32
    use iso_c_binding
    use assertf
    use mod_perceptron
    implicit none

    ! Allocate all the training inputs and outputs
    real(real32) :: train_inputs(SAMPLE_SIZE, WIDTH * HEIGHT)
    real(real32) :: train_outputs(SAMPLE_SIZE)

    ! Catch all the training examples
    
    call srand(CHECK_SEED)      ! set the seed
    
    call prepare_training_data(train_inputs, train_outputs)
    
contains

    ! TODO: Create a two functions one to generate the circle and second to generate  rectangle 
    
    ! prepare_training_data: Sets all randomly all the data
    subroutine prepare_training_data(train_inputs, train_outputs)
        real(real32), intent(in out) :: train_inputs(:, :) 
        real(real32), intent(in out) ::  train_outputs(:)
        
        real(real32) :: matrix(WIDTH, HEIGHT) ! Create the matrix
        integer(int32) :: i, cor
        
        ! Iterate each sample and generate 
        do i = 1, SAMPLE_SIZE
            cor = random_range(1, 2)
            if (cor == 1) then ! Generate a rectangle
                
            else    ! Generate a circle randomly
                
            end if
        end do
    end subroutine prepare_training_data
    

    ! random_range: Return a random number from a range of numbers
    function random_range(low, high)
        integer(int32), intent(in) :: low, high
        integer(int32) :: random_range

        assert(high > low)     ! Check the high and low
        random_range = low + int(rand() * (high - low + 1))
    end function random_range
    
    
end program p_rectangle_circle
