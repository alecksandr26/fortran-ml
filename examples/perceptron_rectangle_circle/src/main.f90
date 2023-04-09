#include <assertf.h>
! include the default configuration
#include "config.h"

#define FILE_BRAIN_NAME "brain.ppm"

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
    real(real32) :: train_inputs(TRAINING_SIZE, WIDTH * HEIGHT)
    real(real32) :: train_outputs(TRAINING_SIZE)
    real(real32) :: test_inputs(TESTING_SIZE, WIDTH * HEIGHT)
    real(real32) :: test_outputs(TESTING_SIZE)
    character(len = 50) :: files_name(TRAINING_SIZE)

    integer(int32) :: i, sum
    
    ! Generate the weights
    real(real32) :: weigths(WIDTH * HEIGHT), results(TESTING_SIZE)

    ! Allocate the perceptron size
    type(perceptron) :: per

    assert(TRAINING_SIZE >= TESTING_SIZE)

    print *, "[INFO] Loading the brain" 
    call load_brain(per, weigths)
    print *, "[INFO] Brain loaded"

    call p_init(per, weigths, per%b)
    
    ! Catch all the training examples
    print *, "[INFO] Preparing the training data" 
    call prepare_data(train_inputs, train_outputs, "train", files_name)
    print *, "[INFO] Training data prepared"

    ! Train the perceptron
    print *, "[INFO] Training perceptron"
    call p_train(per, train_inputs, train_outputs, 0.01, 100000)
    print *, "[INFO] Perceptron trained"

    ! Test the perceptron
    print *, "[INFO] Preparing the testing data"
    call prepare_data(test_inputs, test_outputs, "test", files_name)
    print *, "[INFO] Testing data prepared"

    print *, "[INFO] Testing perceptron"
    call p_test(per, test_inputs, results)
    print *, "[INFO] Perceptron tested"

    sum = 0
    do i = 1, TESTING_SIZE
        if (results(i) == test_outputs(i)) then
            sum = sum + 1
        else
            print *, "[INFO] test fail ", files_name(i)
        end if
    end do

    ! Print the results
    print *, (sum / real(TESTING_SIZE)) * 100.0, sum, TESTING_SIZE

    ! Save the brain
    print *, "[INFO] Saving new brain"
    call save_brain(per)
    print *, "[INFO] Brain saved"
    
    call p_free(per)
    
contains

    ! load_brain: To load the brain of the perceptron in a file
    subroutine load_brain(per, weigths)
        type(perceptron), intent(in out) :: per
        real(real32), intent(out) :: weigths(:)
        
        real(real32) :: brain(HEIGHT, WIDTH)
        integer(int32) :: iostat, i, j, row, column
        character(len = 3) :: pixel

        open(unit = 10, file = FILE_BRAIN_NAME, action = "read", iostat = iostat, status = "old", &
            access = "stream")

        if (iostat /= 0) then
            print *, "[INFO] No brain detected" 
            call random_number(weigths)
            call random_number(per%b)
            return              ! Exit from the subroutine
        endif
        print *, "[INFO] Brain detected"
        
        do i = 1, HEIGHT * PPM_SCALER
            do j = 1, WIDTH * PPM_SCALER
                if (i / PPM_SCALER > 1) then
                    row = i / PPM_SCALER
                else
                    row = 1
                end if
                
                if (j / PPM_SCALER > 1) then
                    column = j / PPM_SCALER
                else
                    column = 1
                end if

                ! Read 3 bytes
                read(10) pixel

                ! Extract the whole brain
                brain(row, column) = ichar(pixel(1:1)) / 255.0
            end do
        end do

        ! Catch the weights
        weigths = reshape(brain, (/WIDTH * HEIGHT/))
        ! Finally read the bias
        read(10) per%b
        close(10)
    end subroutine load_brain

    ! save_brain: To save the brain of the perceptron in a file
    subroutine save_brain(per)
        type(perceptron), intent(in) :: per
        real(real32) :: brain(HEIGHT, WIDTH), weigths(HEIGHT * WIDTH)

        call p_get_weights(per, weigths)
        ! Catch the matrix
        brain = reshape(weigths, (/HEIGHT,  WIDTH/))

        ! Save the brain
        call mat_save_as_ppm(brain, FILE_BRAIN_NAME)
        
        ! Then write the bias
        open(unit = 10, file = FILE_BRAIN_NAME, action = "write", status = "old", position = "append", &
            access = "stream", form = "unformatted")
        write(10) per%b      ! Write the real
        close(10)
    end subroutine save_brain
    
    ! prepare_data: Generates random inputs and outputs for the treanning
    subroutine prepare_data(inputs, outputs, prefix, files_name)
        real(real32), intent(in out) :: inputs(:, :)
        real(real32), intent(in out) :: outputs(:)
        character(len = *), intent(in) :: prefix
        character(len = *), intent(in out) :: files_name(:)
        
        character(len = 50) :: file_path
        real(real32) :: mat_for_sample(WIDTH, HEIGHT) ! The used matrix for each examplen
        integer(int32) :: i, cor, circle_c, rect_c, n


        rect_c = 0
        circle_c = 0
        n = size(outputs)

        do i = 1, n
            cor = random_range(1, 2)
            call mat_fill_rect(mat_for_sample, 0, 0, WIDTH, HEIGHT, 0.0)

            if (cor == 1) then  ! rectangle
                call mat_random_rect(mat_for_sample)
                write(file_path, "(a, i0, a)") "data/" // prefix // "_rect-", rect_c, ".ppm"
                rect_c = rect_c + 1
                outputs(i) = 1
            else
                call mat_random_circle(mat_for_sample)
                write(file_path, "(a, i0, a)") "data/" // prefix // "_circle-", circle_c, ".ppm"
                circle_c = circle_c + 1
                outputs(i) = -1
            endif
            
            ! Catch the generated data
            inputs(i, :) = reshape(mat_for_sample, (/WIDTH * HEIGHT/))
            files_name(i) = file_path
            
            ! Write the matrix
            call mat_save_as_ppm(mat_for_sample, file_path)
        end do
    end subroutine prepare_data
end program p_rectangle_circle
