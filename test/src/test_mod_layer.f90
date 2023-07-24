program test_mod_layer
  use iso_fortran_env, only : real32, int32
  use assertf
  use mod_layer
  implicit none

  type(layer) :: l
  real(real32) :: output = 0.0

  call layer_init(l, 2, 1)
  call layer_feedforward(l, [1.0, 2.0], output)
  call layer_free(l)
end program test_mod_layer
  



  
