F = gfortran
PY = python3
AR = ar rc
LATEX = pdflatex
MAKE = make

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

OBJS = $(addprefix $(OBJ_DIR)/, mod_perceptron.o \
				mod_linear_regression.o\
				mod_neuron.o)

BINS = $(addprefix $(BIN_DIR)/, )
TESTS = $(addprefix $(TEST_BIN_DIR)/, 	test_mod_perceptron.out \
					test_mod_linear_regression.out\
					test_mod_neuron.out\
					test_mod_neuron2.out)

EXAMPLES = $(patsubst $(EXAMPLE_DIR)/%/Makefile, $(EXAMPLE_DIR)/%/main.out, \
			$(wildcard $(EXAMPLE_DIR)/*/Makefile)) # Fetch The whole directories
DOC = $(addprefix $(DOC_DIR)/, main.pdf)

LIB =  $(addprefix $(LIB_DIR)/, libmlc.a)

EXAMPLE_DIRS = $(wildcard $(EXAMPLE_DIR)/*/)


.PHONY: all clean
all: $(OBJS) $(TESTS) $(LIB) $(EXAMPLES) $(DOC)

$(OBJ_DIR):
	mkdir -p $@

$(BIN_DIR):
	mkdir -p $@

$(TEST_BIN_DIR):
	mkdir -p $@

$(LIB_DIR):
	mkdir -p $@

# The objects 
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.f90 | $(OBJ_DIR)
	$(F) $(F_FLAGS) -c $< -J$(OBJ_DIR)/ -o $@ $(ASSERT_FLAGS)

# Create the lib with all the objects
$(LIB): $(OBJS) | $(LIB_DIR)
	$(AR) $@ $^

# Compiling for the module of assert
$(TEST_BIN_DIR)/test_%.out: $(TEST_SRC_DIR)/test_%.f90 $(LIB) | $(TEST_BIN_DIR)
	cp $(OBJ_DIR)/*.mod $(dir $<)
	$(F) $(F_FLAGS) $^ -o $@ $(ASSERT_FLAGS)

# The binary execution
$(BIN_DIR)/%.out: $(SRC_DIR)/%.f90 $(LIB) | $(BIN_DIR)
	$(F) $(F_FLAGS) $< $(LIB) -o $@

test_%.out: $(TEST_BIN_DIR)/test_%.out
	valgrind --leak-check=full --show-leak-kinds=all ./$<

# Compile the documents
$(DOC_DIR)/%.pdf: $(DOC_DIR)/%.tex
	cd $(DOC_DIR) && $(LATEX) $(notdir $<)


$(EXAMPLE_DIR)/%/main.out: $(EXAMPLE_DIR)/%/Makefile $(LIB)
	cp $(wildcard $(OBJ_DIR)/*.mod) $(dir $<)
	cp $(LIB) $(dir $<)
	cd $(dir $<) && make

# Execute the sub makefile
%/main.out: $(EXAMPLE_DIR)/%/main.out
	cd $(dir $<) && make run

clean:
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

ifneq ("$(wildcard $(DOC_DIR)/*.pdf)", "")
	rm $(wildcard $(DOC_DIR)/*.pdf)
endif

ifneq ("$(wildcard $(EXAMPLE_DIR))", "")
	for dir in $(EXAMPLE_DIRS); do	\
		cd "$$dir";		\
		$(MAKE) clean;		\
		cd ../../;		\
	done
endif

doc: $(DOC)
