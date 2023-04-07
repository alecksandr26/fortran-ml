! Simple module to deal with the circle generation and that stuff
#include <assertf.h>
#include "config.h"

module mod_circle
    use iso_fortran_env, only: real32, int32
    use assertf
    use mod_utils

    private
    public mat_fill_circle, mat_random_circle
    
contains

    ! mat_fill_circle: To fills the matrix by given a circle
    subroutine mat_fill_circle(matrix, cx, cy, r, val)
        real(real32), intent(in out) :: matrix(:, :)
        integer(int32), intent(in) :: cx, cy, r
        real(real32), intent(in) :: val
        
        integer(int32) :: x0, y0, x1, y1

        ! Iterators 
        integer(int32) :: x, y

        integer(int32) :: dx, dy

        assert(r > 0)

        x0 = clampi(cx - r, 1, WIDTH)
        y0 = clampi(cy - r, 1, HEIGHT)
        x1 = clampi(cx + r, 1, WIDTH)
        y1 = clampi(cy + r, 1, HEIGHT)

        do y = y0, y1
            do x = x0, x1
                dx = x - cx
                dy = y - cy

                ! Pythagorean theorem
                ! wiki: https://en.wikipedia.org/wiki/Pythagorean_theorem
                if (dx * dx + dy * dy <= r * r) then
                    matrix(y, x) = val
                end if
            end do
        end do
    end subroutine mat_fill_circle

    ! mat_random_circle: To generate a random circle
    subroutine mat_random_circle(matrix)
        real(real32), intent(in out) :: matrix(:, :)
        integer(int32) :: cx, cy, r

        ! Generate a random center
        cx = random_range(4, WIDTH - 2)
        cy = random_range(4, HEIGHT - 2)
        r = random_range(2, WIDTH / 2)
        
        if (r > cx) r = cx
        if (r > cy) r = cy
        if (r > WIDTH - cx) r = WIDTH - cx
        if (r > HEIGHT - cy) r = HEIGHT - cy
        if (r < 2) r = 2

        ! Fill the matrix
        call mat_fill_circle(matrix, cx, cy, r, 1.0)
    end subroutine mat_random_circle
end module mod_circle
    
