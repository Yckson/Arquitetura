#include <stdio.h>
#include <ctype.h>

void limparString(char *str) {
    int i = 0, j = 0;

    while (str[i] != '\0') {
        if (isalpha(str[i])) {       // Verifica se o caractere é uma letra
            str[j] = str[i];         // Copia a letra para a posição correta
            j++;
        }
        i++;
    }
    str[j] = '\0';                   // Adiciona o caractere nulo no final
}

int main() {
    char texto[] = "~arr-oz2";
    
    limparString(texto);
    
    printf("String limpa: %s\n", texto);  // Saída: "arrozz"
    
    return 0;
}
