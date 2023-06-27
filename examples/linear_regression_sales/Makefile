F = gfortran
PY = python3

F_FLAGS = -ggdb -pedantic -Wall -cpp
ASSERT_FLAGS = -I /usr/include -lassertf

DATA_FILE = data.txt
PYTHON_PLOT_FILE = plot.py
OBJS =
BIN = main.out
LIB = libmlc.a

$(BIN): main.f90 $(OBJS)
	$(F) $(F_FLAGS) $^ $(OBJS) $(LIB) -o $@ $(ASSERT_FLAGS)

# The objects 
%.o: %.f90
	$(F) $(F_FLAGS) -c $< -o $@ $(ASSERT_FLAGS)

run: $(BIN)
	./$(BIN) > $(DATA_FILE)
	$(PY) $(PYTHON_PLOT_FILE) $(DATA_FILE)

clean:
	rm -f -r $(LIB) $(OBJS) $(BIN) $(DATA_FILE) $(wildcard *.mod) $(wildcard *.png)
