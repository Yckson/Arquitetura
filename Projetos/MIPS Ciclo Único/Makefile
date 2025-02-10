# Compiler
IVERILOG = iverilog

# Source files
SRC = $(shell find . -name "*.v")

# Output executable (dentro da pasta ./GTK_WAVE)
OUT = ./GTK_WAVE/mips_sim

# Default rule: compila o simulador
all: $(OUT)

$(OUT): $(SRC)
	@mkdir -p ./GTK_WAVE
	$(IVERILOG) -o $(OUT) $(SRC)

# Regra para executar a simulação e abrir o GTKWave com o arquivo de configuração
run: $(OUT)
	vvp $(OUT)
	gtkwave dump.vcd ./GTK_WAVE/GTK_STYLE.gtkw

# Limpeza dos arquivos gerados
clean:
	rm -f $(OUT) *.vcd

.PHONY: all run clean
