@echo off
REM Habilita a expansão de variáveis dentro de loops
setlocal EnableDelayedExpansion

REM Verifica o argumento passado; se nenhum for fornecido, assume "all"
if "%~1"=="" goto all
if /I "%~1"=="all" goto all
if /I "%~1"=="run" goto run
if /I "%~1"=="clean" goto clean

echo Uso: %~nx0 [all^|run^|clean]
goto end

:all
echo.
echo === Compilando o simulador ===

REM Cria a pasta GTK_WAVE caso ela não exista
if not exist "GTK_WAVE" mkdir "GTK_WAVE"

REM Concatena recursivamente todos os arquivos .v (Verilog) encontrados na pasta atual e subpastas
set SOURCES=
for /R %%f in (*.v) do (
    set SOURCES=!SOURCES! "%%f"
)

REM Exibe os arquivos encontrados (opcional; descomente se desejar visualizar)
REM echo Arquivos Verilog encontrados: !SOURCES!

REM Compila usando o iverilog; o executável de simulação será gerado em GTK_WAVE\mips_sim
iverilog -o "GTK_WAVE\mips_sim" !SOURCES!
if errorlevel 1 (
    echo.
    echo [ERRO] Falha na compilacao.
    goto end
)
echo.
echo Compilacao concluida com sucesso.
goto end

:run
echo.
echo === Executando a simulacao ===

REM Primeiro, compila (garante que o simulador esteja atualizado)
call %~nx0 all

REM Executa a simulação
vvp "GTK_WAVE\mips_sim"
if errorlevel 1 (
    echo.
    echo [ERRO] Erro na execucao do simulador.
    goto end
)

REM Abre o GTKWave com o arquivo de dump e o estilo
echo.
echo Abrindo o GTKWave...
gtkwave dump.vcd "GTK_WAVE\GTK_STYLE.gtkw"
goto end

:clean
echo.
echo === Limpando os arquivos gerados ===

REM Remove o arquivo gerado pela compilacao e os arquivos .vcd (se existirem)
if exist "GTK_WAVE\mips_sim" del /q "GTK_WAVE\mips_sim"
del /q *.vcd 2>nul
echo.
echo Limpeza concluida.
goto end

:end
endlocal
