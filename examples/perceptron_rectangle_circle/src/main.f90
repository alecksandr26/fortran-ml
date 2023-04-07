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

    matrix = 0
    ! Catch all the training examples
    
    call prepare_training_data(train_inputs, train_outputs)
    ! call mat_fill_rect(matrix, 0, 0, WIDTH / 2, HEIGHT / 2, 1.0)

    ! call mat_fill_circle(matrix, WIDTH / 2, HEIGHT / 2, 8, 1.0)
    ! call mat_save_as_ppm(matrix, "mat.ppm")
    
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
            
            ! Write the matrix
            call mat_save_as_ppm(mat_for_sample, file_path)
        end do
    end subroutine prepare_training_data
end program p_rectangle_circle
