F = gfortran
PY = python3
AR = ar rc
PDF = pdflatex

F_FLAGS = -ggdb -pedantic -Wall -cpp -fopenmp
ASSERT_FLAGS = -I /usr/include -lassertf

SRC_DIR = src
EXAMPLE_DIR = examples
OBJ_DIR = obj
BIN_DIR = bin
LIB_DIR = lib
TEST_DIR = test
TEST_BIN_DIR = $(addprefix $(TEST_DIR)/, bin)
TEST_SRC_DIR = $(addprefix $(TEST_DIR)/, src)
DOC_DIR = docs

OBJS = $(addprefix $(OBJ_DIR)/, mod_perceptron.o)
BINS = $(addprefix $(BIN_DIR)/, )
TESTS = $(addprefix $(TEST_BIN_DIR)/, test_mod_perceptron.out)
EXAMPLES = $(patsubst $(EXAMPLE_DIR)/%/Makefile, $(EXAMPLE_DIR)/%/main.out, $(wildcard $(EXAMPLE_DIR)/*/Makefile)) # Fetch The whole directories
DOCS = $(addprefix $(DOC_DIR)/, perceptron_notes.pdf)

# A simple library with all the code
LIB =  $(addprefix $(LIB_DIR)/, libmlc.a)

define newline

endef

all: $(OBJ_DIR) $(TEST_BIN_DIR) $(LIB_DIR) $(OBJS) $(TESTS) $(LIB) $(EXAMPLES) $(DOCS)

$(OBJ_DIR):
	mkdir -p $@

$(BIN_DIR):
	mkdir -p $@

$(TEST_BIN_DIR):
	mkdir -p $@

$(LIB_DIR):
	mkdir -p $@

# The objects 
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.f90 $(OBJ_DIR) 
	$(F) $(F_FLAGS) -c $< -J $(OBJ_DIR)/ -o $@ $(ASSERT_FLAGS)

# Create the lib with all the objects
$(LIB): $(OBJS) $(LIB_DIR)
	$(AR) $@ $<

# Compiling for the module of assert
$(TEST_BIN_DIR)/test_%.out: $(TEST_SRC_DIR)/test_%.f90 $(OBJ_DIR)/%.o
	cp $(basename $(word 2, $^)).mod $(TEST_SRC_DIR)/ # Copy the module file
	$(F) $(F_FLAGS) $^ -o $@ $(ASSERT_FLAGS)

# The binary execution
$(BIN_DIR)/%.out: $(SRC_DIR)/%.f90 $(LIB)
	$(F) $(F_FLAGS) $< $(LIB) -o $@

test_%.out: $(TEST_BIN_DIR)/test_%.out
	valgrind --leak-check=full --show-leak-kinds=all ./$<

# Compile the documents
$(DOC_DIR)/%.pdf: $(DOC_DIR)/%.tex
	$(PDF) -output-directory $(dir $@) $<

# Execute the sub makefile

$(EXAMPLE_DIR)/%/main.out: $(EXAMPLE_DIR)/%/Makefile $(LIB)
	cp $(OBJ_DIR)/*.mod $(dir $<)
	cp $(LIB) $(dir $<)
	cd $(dir $<) && make

# Execute the example and catch the data
%.out: $(EXAMPLE_DIR)/%/main.out
	cd $(dir $<) && make run

# Clean everything
clean_$(BIN_DIR)/%.out:
	rm $(patsubst clean_%, %, $@)

clean_$(OBJ_DIR)/%.o:
	rm $(patsubst clean_%, %, $@)

clean_$(TEST_BIN_DIR)/%.out:
	rm $(patsubst clean_%, %, $@)

clean_$(EXAMPLE_DIR)/%.out:
	cd $(dir $(patsubst clean_%, %, $@)) && make clean

clean: $(addprefix clean_, $(wildcard $(BIN_DIR)/*.out)) \
	   $(addprefix clean_, $(wildcard $(OBJ_DIR)/*.o)) \
       $(addprefix clean_, $(wildcard $(TEST_BIN_DIR)/*.out)) \
	   $(addprefix clean_, $(wildcard $(EXAMPLE_DIR)/*/*.out))
ifneq ("$(wildcard $(OBJ_DIR))", "")
	rm -r $(OBJ_DIR)
endif

ifneq ("$(wildcard $(BIN_DIR))", "")
	rm -r $(BIN_DIR)
endif

ifneq ("$(wildcard $(TEST_BIN_DIR))", "")
	rm -r $(TEST_BIN_DIR)
endif

ifneq ("$(wildcard $(LIB_DIR))", "")
	rm -r $(LIB_DIR)
endif
