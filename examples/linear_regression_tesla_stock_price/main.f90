
#include <assertf.h>
#define CSV_FILE "TSLA.csv"
#define MAX_AMOUNT_FIELDS 100
#define FD 10

program example_stock_price
  use, intrinsic :: iso_fortran_env, only : iostat_end
  use iso_fortran_env, only: real32, int32
  use assertf
  use mod_linear_regression
  implicit none

  character(len=100) :: line
  character(len=100) :: fields(MAX_AMOUNT_FIELDS)
  character(len=100) :: head_fields(MAX_AMOUNT_FIELDS)
  integer(int32) :: status, unit, amount_fields, foo = 0, i, lines, k
  real(real32), allocatable :: inputs(:, :), outputs(:)
  type(linear_regression) :: lr
  real(real32) :: output

  unit = FD
  lines = count_lines()
  ! Allocate the memory for the inputs for training
  
  open(unit, file = CSV_FILE, action='read', status='old', iostat = status)
  
  if (status /= 0) then
     write (*, *) 'Error opening file:', status
     stop
  end if
  
  
  read(unit, '(A)', iostat = status) line
  if (status == iostat_end) then
     stop ! Exit loop at end of file
  else if (status /= 0) then
     write (*, *) "Error reading the file"
     stop
  end if
  
  amount_fields = 0
  call parse_a_line(line, head_fields, amount_fields)
  assert(amount_fields > 0)
  
  ! allocate(inputs(6, lines - 1))
  allocate(inputs(5, lines - 1))
  allocate(outputs(lines - 1))

  k = 1
  do
     read(unit, '(A)', iostat = status) line
     if (status == iostat_end) then
        exit ! Exit loop at end of file
     else if (status /= 0) then
        write (*, *) "Error reading the file"
        stop
     end if

     call parse_a_line(line, fields, foo)
     assert(foo == amount_fields)
     i = 1

     ! Capture the data for input
     inputs(1, k) = 1                ! The input to be multibply with the bias
     read(fields(2), *) inputs(2, k) ! Cast Open
     read(fields(3), *) inputs(3, k) ! Cast High
     read(fields(3), *) inputs(4, k) ! Cast Low
     read(fields(5), *) outputs(k)   ! Cast close the prediction valuee
     inputs(5, k) = k                ! The day
     ! read(fields(7), *) inputs(6, k) ! The volumn of stock exchanged
     
     k = k + 1
  end do

  ! Close the file
  close(unit, status='keep')

  ! Print the information all the components
  print *, "x2: ", inputs(2, :)
  print *, "x3: ", inputs(3, :)
  print *, "x4: ", inputs(4, :)
  print *, "x5: ", inputs(5, :)
  ! print *, "x6: ", inputs(6, :)
  print *, "y: ", outputs

  ! Assign this initial weights 
  ! call lr_init(lr, [0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
  call lr_init(lr, [0.0, 0.0, 0.0, 0.0, 0.0])
  call lr_train(lr, inputs, outputs, 0.000000001, 10000000)
  
  write(*, '(A)', advance='no') "res: "
  do i = 1, size(inputs, 2)
     call lr_test(lr, inputs(:, i), output)
     write(*, '(F0.1, A)', advance='no') output, ' '
     output = 0.0
  end do
  write(*,*)

  print *, "w: ", lr%w
  
  call lr_free(lr)
  
  deallocate(inputs)
  deallocate(outputs)
contains

  function count_lines() result(count)
    integer(int32) :: unit, status, count
    character(len=100) :: line
    
    unit = FD
    ! Open the CSV file
    open(unit, file=CSV_FILE, action='read', status='old', iostat = status)

    if (status /= 0) then
       write (*, *) 'Error opening file:', status
       stop
    end if

    count = 0
    do
     read(unit, '(A)', iostat = status) line
     if (status == iostat_end) then
        exit ! Exit loop at end of file
     else if (status /= 0) then
        write (*, *) "Error reading the file"
        stop
     end if
     count = count + 1
  end do
  close(unit)
  end function count_lines
  
  subroutine parse_a_line(line, fields, amount_fields)
    character(len=100), intent(in) :: line
    character(len=100), intent(out) :: fields(:)
    integer(int32), intent(out) :: amount_fields
    integer(int32) :: i, delimiter_pos, n

    i = 1
    n = 1
    do while (i <= len(line))
       ! Find the position of the delimiter
       delimiter_pos = index(line(i:), ',')
       if (delimiter_pos == 0) then
          delimiter_pos = len(line(i:))
       end if

       ! Extract the field
       fields(n) = line(i : i + delimiter_pos - 2)

       ! Iterate to the next
       i = i + delimiter_pos
       n = n + 1
    end do

    amount_fields = n
  end subroutine parse_a_line
end program example_stock_price


