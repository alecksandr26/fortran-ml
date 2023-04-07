#include <assertf.h>
! include the default configuration
#include "config.h"

! TODO: Find data for circles and rectangles

program p_rectangle_circle 
    use iso_fortran_env, only: real32, int32
    use iso_c_binding
    use assertf
    use mod_perceptron
    use mod_rect
    use mod_utils
    use mod_circle
    
    implicit none

    ! Allocate all the training inputs and outputs
    real(real32) :: train_inputs(SAMPLE_SIZE, WIDTH * HEIGHT)
    real(real32) :: train_outputs(SAMPLE_SIZE)
    real(real32) :: matrix(HEIGHT, WIDTH)

    integer(int32) :: i, sum
    
    ! Generate the weights
    real(real32) :: weigths(WIDTH * HEIGHT), bias
    real(real32) :: results(SAMPLE_SIZE)

    ! Allocate the perceptron size
    type(perceptron) :: per

    ! set random values to the weights of the perceptron
    call random_number(weigths)
    call random_number(bias)

    call p_init(per, weigths, bias)

    matrix = 0
    ! Catch all the training examples
    call prepare_training_data(train_inputs, train_outputs)

    ! Train the perceptron

    call p_train(per, train_inputs, train_outputs, 0.01, 100)

    ! Test the perceptron
    call p_test(per, train_inputs, results)

    do i = 1, SAMPLE_SIZE
        if (train_outputs(i) == results(i)) sum = sum + 1
    end do

    ! write(*, "(f3.3), (a)") (sum / real(SAMPLE_SIZE)) * 100.0, " %"
    print *, (sum / int(SAMPLE_SIZE)) * 100.0
    print *, train_outputs(1:10)
    print *, results(1:10)
    
    call p_free(per)
    
contains
    ! TODO: Create two functions one to generate the circle and to generate rectangle
    
    ! prepare_training_data: Sets all randomly all the data
    subroutine prepare_training_data(train_inputs, train_outputs)
        real(real32), intent(in out) :: train_inputs(:, :) 
        real(real32), intent(in out) ::  train_outputs(:)
        
        character(len = 20) :: file_path
        real(real32) :: mat_for_sample(WIDTH, HEIGHT) ! The used matrix for each example
        integer(int32) :: i, cor, circle_c, rect_c
        
        rect_c = 0
        circle_c = 0
        
        ! Iterate each sample and generate        
        do i = 1, SAMPLE_SIZE
            cor = random_range(1, 2)
            call mat_fill_rect(mat_for_sample, 0, 0, WIDTH, HEIGHT, 0.0)
            
            if (cor == 1) then  ! rectangle
                call mat_random_rect(mat_for_sample)
                write(file_path, "(a, i0, a)") "data/rect-", rect_c, ".ppm"
                rect_c = rect_c + 1
            else
                call mat_random_circle(mat_for_sample)
                write(file_path, "(a, i0, a)") "data/circle-", circle_c, ".ppm"
                circle_c = circle_c + 1
            endif

            ! Catch the generated data
            train_inputs(i, :) = reshape(mat_for_sample, (/WIDTH * HEIGHT/))
            train_outputs(i) = cor - 1
            
            ! Write the matrix
            call mat_save_as_ppm(mat_for_sample, file_path)
        end do
    end subroutine prepare_training_data
end program p_rectangle_circle
