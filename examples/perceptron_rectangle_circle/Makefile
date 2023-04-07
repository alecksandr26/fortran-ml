F = gfortran

F_FLAGS = -ggdb -pedantic -Wall -cpp
ASSERT_FLAGS = -I /usr/include -lassertf

OBJ_DIR = obj
SRC_DIR = src
DATA_DIR = data

OBJS = $(addprefix $(OBJ_DIR)/, utils.o rect.o circle.o main.o)
BIN = main.out
LIB = libmlc.a

$(BIN): $(OBJS)
	$(F) $(F_FLAGS) $^ $(LIB) -o $@ $(ASSERT_FLAGS)

$(OBJ_DIR):
	mkdir -p $@

$(DATA_DIR):
	mkdir -p $@

# The objects 
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.f90 $(OBJ_DIR)
	$(F) $(F_FLAGS) -c $< -J $(OBJ_DIR)/ -o $@  $(ASSERT_FLAGS)

run:    $(DATA_DIR)
	./$(BIN)

clean:
	rm -f -r $(LIB) $(OBJS) $(BIN) $(wildcard $(OBJ_DIR)/*.mod) $(wildcard $(DATA_DIR)/*.ppm) mod_perceptron.mod
	rm -f -r $(OBJ_DIR) $(DATA_DIR)



