! Simple module to deal with the rectangles generation and that stuff

#include <assertf.h>
! include the default configuration
#include "config.h"             
    
module mod_rect
    use iso_fortran_env, only: real32, int32
    use assertf
    use mod_utils

    private
    public mat_fill_rect, mat_random_rect
contains

     ! mat_fill_rect: Fills the matrix with random data
    subroutine mat_fill_rect(matrix, x, y , w , h, val)
        real(real32), intent(in out) :: matrix(: , :)
        integer(int32), intent(in) :: x, y, w, h
        real(real32), intent(in) :: val
        
        integer(int32) :: x0, y0, x1, y1
        ! Iterator
        integer(int32) :: i, j
        
        ! Check the corret inputs
        assert(w > 0)
        assert(h > 0)

        ! Adjust the limits 
        x0 = clampi(x, 1, WIDTH)
        y0 = clampi(y, 1, HEIGHT)
        x1 = clampi(x0 + w - 1, 0, WIDTH)
        y1 = clampi(y0 + h - 1, 0, HEIGHT)

        do i = y0, y1
            do j = x0,  x1
                matrix(i, j) = val
            end do
        end do
    end subroutine mat_fill_rect

    ! mat_random_rect: Generates a random rectangle in the matrix
    subroutine mat_random_rect(matrix)
        real(real32), intent(in out) :: matrix(:, :)
        integer(int32) :: x, y, w, h

        ! Random point
        x = random_range(1, WIDTH - 2)
        y = random_range(1, HEIGHT - 2)

        ! Get a distance
        w = WIDTH - x
        h = HEIGHT - y
        
        if (w < 3) w = 3
        if (h < 3) h = 3
        
        w = random_range(1, w)
        h = random_range(1, h)

        ! Fill the rectangle with the configuration
        call mat_fill_rect(matrix, x, y, w, h, 1.0)
    end subroutine mat_random_rect
end module mod_rect

    
