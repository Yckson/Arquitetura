# Compiler
IVERILOG = iverilog

# Source files
SRC = $(shell find . -name "*.v" ! -path "./PC/FetchUnit.v" ! -path "./@Arquivos do Professor/*")

# Output executable
OUT = mips_sim

# Default rule
all: $(OUT)

$(OUT): $(SRC)
	$(IVERILOG) -o $(OUT) $(SRC)

# Clean rule
clean:
	rm -f $(OUT) *.vcd

.PHONY: all clean
