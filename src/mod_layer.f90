
module mod_layer
  use iso_fortran_env, only : int32, real32
  implicit none

  private
  public layer_init, layer_free, layer_feedforward, layer
  
  type layer
     real(real32), allocatable :: w(:, :), b(:)
     integer(int32) :: rows_w, cols_w, rows_b
  end type layer
  
contains
  subroutine layer_init(l, input, output)
    type(layer), intent(out) ::  l
    integer(int32), intent(in) :: input, output

    l%rows_w = input
    l%cols_w = output
    l%rows_b = output

    allocate(l%w(input, output))
    allocate(l%b(output))

    call random_seed()

    call random_number(l%w);
    call random_number(l%b);
  end subroutine layer_init

  subroutine layer_free(l)
    type(layer), intent(out) :: l
    deallocate(l%w)
    deallocate(l%b)
  end subroutine layer_free

  subroutine layer_feedforward()
    
  end subroutine layer_feedforward
end module mod_layer


  
