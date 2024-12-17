:: Compilar com iverilog
iverilog -o output -f arquivos.f

:: Executar o simulador
vvp output

:: Abrir o GTKWave
gtkwave ULA_OUTPUT.vcd

pause
