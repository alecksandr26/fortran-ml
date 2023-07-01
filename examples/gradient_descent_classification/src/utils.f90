#include <assertf.h>
! include the default configuration
#include "config.h" 

! Simple module with general functions

module mod_utils
  use iso_fortran_env, only: real32, int32
  use assertf

  private
  public clampi, mat_save_as_ppm, random_range

contains

  ! clampi: To fix all the positions generated
  integer(int32) function clampi(pos, low, high)
    integer(int32), intent(in) :: pos, low, high

    if (pos < low) then
       clampi = low
    else if (pos > high) then
       clampi = low
    else
       clampi = pos
    end if
  end function clampi

  ! mat_save_as_ppm: To save the matrix as ppm format image
  ! wiki: https://en.wikipedia.org/wiki/Netpbm
  subroutine mat_save_as_ppm(matrix, file_path)
    real(real32), intent(in) :: matrix(:, :)
    character(len = *), intent(in) :: file_path
    ! The error variable and the iterators
    integer(int32) :: iostat, i, j, row, column
    character(len = 3) :: pixel
    character(len = 50) :: width, height
    real(real32) :: color

    ! Open the file to be able to write raw bytes
    open(unit = 10, file = file_path, action = "write", status = "replace", iostat = iostat, &
         access = "stream", form = "unformatted")

    ! Check for errors
    if (iostat /= 0) then
       print *, "Error: creating the file: ", file_path
       stop    ! Stop the program
    end if

    ! Write the ppm header file
    write (10) "P6", char(10)
    write (width, "(i0)") WIDTH * PPM_SCALER
    write (height, "(i0)") HEIGHT * PPM_SCALER
    write (10) width, " ", height, " 255", char(10)

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

          color = 255.0 * matrix(row, column)

          pixel(1:1) = achar(mod(int(color), 256))
          pixel(2:2) = achar(0)
          pixel(3:3) = achar(0)
          write (10) pixel
       end do
    end do

    close(unit = 10, status = "keep")
  end subroutine mat_save_as_ppm


  ! random_range: Return a random number from a range of numbers
  integer(int32) function random_range(low, high)
    integer(int32), intent(in) :: low, high
    real(real32) :: u

    assert(high > low)     ! Check the high and low

    ! Generates a random real number between [0, 1)
    call random_number(u)

    ! Then distribute the number
    random_range = low + floor((high - low + 1) * u)
  end function random_range
end module mod_utils



