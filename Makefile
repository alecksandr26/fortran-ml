F = gfortran
PY = python3

F_FLAGS = -ggdb -pedantic -Wall -cpp
SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
TEST_DIR = test
TEST_BIN_DIR = $(addprefix $(TEST_DIR)/, bin)
TEST_SRC_DIR = $(addprefix $(TEST_DIR)/, src)

OBJS = $(addprefix $(OBJ_DIR)/, )
BINS = $(addprefix $(BIN_DIR)/, )
TESTS = $(addprefix $(TEST_BIN_DIR)/, )

define newline

endef

all: $(OBJ_DIR) $(TEST_BIN_DIR) $(OBJS) $(TESTS)

$(OBJ_DIR):
	mkdir -p $@

$(BIN_DIR):
	mkdir -p $@

$(TEST_BIN_DIR):
	mkdir -p $@

# The objects 
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.f90
	$(F) $(F_FLAGS) -c $< -o $@
	@mv $(basename $(notdir $@)).mod $(SRC_DIR)

$(TEST_BIN_DIR)/test_%.out: $(TEST_SRC_DIR)/test_%.f90 $(OBJ_DIR)/%.o
	$(F) $(F_FLAGS) -c $^ -o $@

# The binary execution
$(BIN_DIR)/%.out: $(SRC_DIR)/%.f90 $(OBJS)
	$(F) $(F_FLAGS) $< $(OBJS) -o $@

test_%.out: $(TEST_BIN_DIR)/test_%.out
	valgrind --leak-check=full --show-leak-kinds=all ./$<

# TODO: Create way to execute the examples or binaries
# run: $(BINS)
# 	./$< > $(basename $<)_output.txt
# 	$(PY) $(SRC_DIR)/plot.py $(basename $<)_output.txt

clean: $(addprefix clean_, $(wildcard $(BIN_DIR)/*.out)) \
	   $(addprefix clean_, $(wildcard $(OBJ_DIR)/*.o)) \
       $(addprefix clean_, $(wildcard $(TEST_BIN_DIR)/*.out))
ifneq ("$(wildcard $(OBJ_DIR))", "")
	rmdir $(OBJ_DIR)
endif

ifneq ("$(wildcard $(BIN_DIR))", "")
	rmdir $(BIN_DIR)
endif

ifneq ("$(wildcard $(TEST_BIN_DIR))", "")
	rmdir $(TEST_BIN_DIR)
endif
