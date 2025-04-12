# Módulo LCD para Altera DE2 Cyclone II

Este projeto contém dois módulos principais para controlar e testar o display LCD da placa Altera DE2 Cyclone II:

1. **LCD_CONTROLLER.v**: Módulo responsável por controlar o display LCD.
2. **LCD_TEST.v**: Módulo de teste que utiliza o `LCD_CONTROLLER` para exibir a mensagem "HELLO WILL" no display.

## Funcionamento do Módulo `LCD_CONTROLLER.v`

O módulo `LCD_CONTROLLER` é responsável por gerenciar a comunicação com o display LCD. Ele implementa uma máquina de estados para inicializar o LCD, enviar comandos e escrever dados.

### Entradas e Saídas

- **Entradas**:
  - `E`: Sinal de habilitação para iniciar a escrita de um byte.
  - `DATA`: Dados de 8 bits a serem enviados ao LCD.
  - `clk`: Clock do sistema.
  - `rst`: Sinal de reset.

- **Saídas**:
  - `LCD_DATA`: Dados enviados ao LCD.
  - `LCD_RW`: Sinal de leitura/escrita (sempre em modo escrita neste projeto).
  - `LCD_EN`: Sinal de habilitação do LCD.
  - `LCD_RS`: Seleção entre comando (0) e dados (1).
  - `LCD_ON`: Liga o display LCD.
  - `LEDR`: LEDs para depuração (opcional).
  - `LCD_STATE`: Estado atual da máquina de estados (para depuração).

### Máquina de Estados

A máquina de estados do `LCD_CONTROLLER` possui os seguintes estados principais:

1. **INIT, INIT2, INIT3**: Inicializam o LCD com comandos específicos.
2. **WAITING_STATE**: Aguarda o sinal `E` para iniciar a escrita de um byte.
3. **WRITE_BYTE_STATE**: Escreve o byte armazenado em `DATA` no LCD.
4. **PULSE_HIGH e PULSE_LOW**: Geram o pulso de habilitação necessário para o LCD processar os dados.

### Configuração Inicial

O controlador inicializa o LCD com os seguintes comandos:
- Configuração de 8 bits, 2 linhas, 5x7 pontos.
- Display ligado, cursor desligado.
- Incremento automático do cursor após cada escrita.

## Funcionamento do Módulo `LCD_TEST.v`

O módulo `LCD_TEST` é um exemplo de uso do `LCD_CONTROLLER`. Ele implementa uma máquina de estados para exibir a mensagem "HELLO WILL" no display LCD.

### Entradas e Saídas

- **Entradas**:
  - `KEY`: Botões da placa para reset e controle.
  - `CLOCK_27`: Clock de 27 MHz da placa.
  - `SW`: Switches para entrada de dados (não utilizados neste exemplo).

- **Saídas**:
  - `LCD_DATA`, `LCD_RW`, `LCD_EN`, `LCD_RS`, `LCD_ON`: Conexões com o LCD.
  - `LCD_BLON`: Liga o backlight do LCD (não disponível na Altera DE2).
  - `LEDG`: LEDs verdes para depuração.
  - `LEDR`: LEDs vermelhos para depuração.

### Máquina de Estados

A máquina de estados do `LCD_TEST` escreve cada caractere da mensagem "HELLO WILL" no LCD, um por vez. Os estados principais são:

1. **WRITE_H, WRITE_E, WRITE_L1, ...**: Escrevem os caracteres "H", "E", "L", etc.
2. **WAIT1**: Aguarda o LCD estar pronto para o próximo caractere.
3. **DONE**: Finaliza a escrita.

### Fluxo de Operação

1. O módulo inicia no estado `WRITE_H` e envia o caractere 'H' ao LCD.
2. Após o LCD processar o caractere, o estado avança para o próximo (e.g., `WRITE_E`).
3. O processo continua até que todos os caracteres sejam escritos.
4. O estado `DONE` indica que a mensagem foi completamente exibida.

### Depuração

Os LEDs verdes (`LEDG`) indicam o estado atual da máquina de estados do `LCD_TEST`. Isso facilita a depuração do fluxo de escrita.

## Como Usar

1. **Conecte o LCD**: Certifique-se de que o display LCD está conectado corretamente aos pinos da placa, conforme especificado no arquivo de atribuição de pinos (`DE2_pin_assignments.csv`).
2. **Compile o Projeto**: Use o Quartus II para compilar os módulos `LCD_CONTROLLER.v` e `LCD_TEST.v`.
3. **Carregue na Placa**: Faça o upload do projeto para a placa Altera DE2 Cyclone II.
4. **Teste**: Pressione o botão de reset (`KEY[0]`) para reiniciar o módulo e exibir a mensagem "HELLO WILL" no LCD.

## Observações

- O módulo `LCD_CONTROLLER` pode ser reutilizado em outros projetos para controlar o LCD.
- O módulo `LCD_TEST` é apenas um exemplo e pode ser modificado para exibir outras mensagens ou implementar funcionalidades adicionais.

## Arquivos

- `LCD_CONTROLLER.v`: Controlador do LCD.
- `LCD_TEST.v`: Módulo de teste para o controlador.
- `DE2_pin_assignments.csv`: Arquivo de atribuição de pinos para a placa Altera DE2 Cyclone II.



## Agradecimento

Agradeço ao professor Calebe Micael de Oliveira pelo desafio de criar este módulo, que proporcionou um grande aprendizado, e ao amigo Rafael Gomes Oliveira Santos pela companhia e apoio durante as várias horas no laboratório de hardware.