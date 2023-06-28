module mod_neuron
  use iso_fortran_env, only : int32, real32
  implicit none

  private
  public n_init, n_free, n_train, n_test, PREDICT, CLASSIFICATION, mse, neuron

  type NEURON_TYPE
     integer(int32) :: val
  end type NEURON_TYPE


  type(NEURON_TYPE), parameter :: PREDICT = NEURON_TYPE(1)
  type(NEURON_TYPE), parameter :: CLASSIFICATION = NEURON_TYPE(2)

  type neuron
     real(real32), allocatable :: w(:)
     type(NEURON_TYPE) :: type
  end type neuron
contains

  real(real32) function mse(ne, inputs, outputs)
    type(neuron), intent(in) :: ne
    real(real32), intent(in) :: inputs(:, :), outputs(:)
    integer(int32) :: n, t, i, m
    real(real32), allocatable :: results(:)

    n = size(outputs)
    m = size(ne%w)
    allocate(results(n))

    mse = 0.0
    do concurrent(t = 1 : n)
       results(t) = ne%w(1)
       do concurrent(i = 2 : m)
          results(t) = results(t) + inputs(t, i - 1) * ne%w(i)
       end do

       select case(ne%type%val)
       case(CLASSIFICATION%val)
          results(t) = 1.0 / (1.0 + exp(- results(t)))
       end select
       
       mse = mse + ((outputs(t) - results(t)) ** 2)
    end do
    
    deallocate(results)
    mse = mse / n
  end function mse

  subroutine n_init(ne, m, type)
    integer(int32), intent(in) :: m
    type(NEURON_TYPE), intent(in) :: type
    type(neuron), intent(out) :: ne
    integer(int32) :: i

    ne%type = type
    ! Add another one for the bias
    allocate(ne%w(m + 1))

    do concurrent(i = 1 : m + 1)
       ne%w(i) = 0.0
    end do
  end subroutine n_init

  subroutine n_free(ne)
    type(neuron), intent(in out) :: ne
    deallocate(ne%w)
  end subroutine n_free


  subroutine n_train(ne, inputs, outputs, lr, nepochs)
    type(neuron), intent(in out) :: ne
    real(real32), intent(in) :: inputs(:, :), outputs(:), lr
    integer(int32), intent(in) :: nepochs
    integer(int32) :: n, t, e, m, i
    real(real32), allocatable :: results(:), errors(:), updates(:)

    n = size(outputs)
    m = size(ne%w)
    allocate(results(n))
    allocate(errors(n))
    allocate(updates(m))

    do e = 1, nepochs
       ! First compute all the errors
       do concurrent(t = 1 : n)
          results(t) = ne%w(1)
          do concurrent(i = 2 : m)
             results(t) = results(t) + inputs(t, i - 1) * ne%w(i)
          end do
          
          select case(ne%type%val)
          case (PREDICT%val)
             errors(t) = outputs(t) - results(t)
          case(CLASSIFICATION%val)
             errors(t) = outputs(t) - 1.0 / (1.0 + exp(- results(t)))
          end select
       end do

       ! Update the weights
       do concurrent(i = 1 : m)
          updates(i) = 0.0
          do concurrent(t = 1 : n)
             select case(ne%type%val)
             case(PREDICT%val)
                if (i == 1) then
                   updates(i) = updates(i) + errors(t)
                else
                   updates(i) = updates(i) + errors(t) * inputs(t, i - 1) 
                end if

             case(CLASSIFICATION%val)
                if (i == 1) then
                   updates(i) = updates(i) + errors(t) * exp(- results(t)) / (1.0 + exp( - results(t)))
                else
                   updates(i) = updates(i) + errors(t) * &
                        (inputs(t, i - 1) * exp(- results(t))) / (1.0 + exp( - results(t)))
                end if
             end select
          end do
          ne%w(i) = ne%w(i) + lr * (2 * updates(i)) / n
       end do
    end do
 
    deallocate(results)
    deallocate(errors)
    deallocate(updates)
  end subroutine n_train


  subroutine n_test(ne, input, output)
    type(neuron), intent(in) :: ne
    real(real32), intent(in) :: input(:)
    real(real32), intent(out) :: output
    integer(int32) :: i, m

    m = size(ne%w)
    output = ne%w(1)
    do concurrent(i = 2 : m)
       output = output + ne%w(i) * input(i - 1)
    end do

    select case(ne%type%val)
    case(CLASSIFICATION%val)
       output = 1.0 / (1.0 + exp(- output))
    end select
  end subroutine n_test
end module mod_neuron
  
  
