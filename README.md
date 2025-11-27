# PixelScript: Linguagem de Programação para Desenho Procedural

## 1. Introdução

Este projeto consiste na criação de uma linguagem de programação de alto nível chamada **PixelScript**, desenvolvida para interagir com uma Máquina Virtual (VM) baseada em navegador (Canvas HTML/JavaScript). O objetivo principal foi demonstrar a aplicação prática de conceitos de Análise Léxica e Sintática, utilizando as ferramentas padrão de mercado **Flex** e **Bison**.

A PixelScript é uma linguagem de domínio específico (DSL) focada na criação de arte procedural e padrões geométricos.

## 2. Objetivos Cumpridos

| Objetivo | Status | Detalhes |
| :--- | :--- | :--- |
| **Criar uma Linguagem de Programação** | ✅ Concluído | A linguagem PixelScript foi criada com foco em desenho procedural. |
| **Estruturas Básicas (Variáveis, Condicionais, Loops)** | ✅ Concluído | Implementação de `VAR`, `SE...SENAO` e `REPETIR...VEZES`. |
| **Análise Léxica e Sintática (Flex/Bison)** | ✅ Concluído | O compilador `pixelscript` foi desenvolvido usando Flex e Bison para gerar código C, que por sua vez gera o Assembly (JavaScript) da VM. |
| **Utilizar uma VM** | ✅ Concluído | O código é interpretado pelo motor JavaScript do navegador (VM). |
| **Criar um Exemplo de Teste** | ✅ Concluído | O script `fibonacci.pixel` demonstra o uso de todas as estruturas. |

## 3. Arquitetura do Compilador

O compilador `pixelscript` funciona em três etapas:

1.  **Análise Léxica (Flex):** O arquivo `lexer.l` lê o código-fonte da PixelScript e o transforma em *tokens* (palavras-chave, identificadores, valores, operadores).
2.  **Análise Sintática (Bison):** O arquivo `parser.y` recebe os tokens e verifica se a sequência obedece à gramática (EBNF). Ações C/C++ são executadas para cada regra sintática reconhecida.
3.  **Geração de Código (C/C++):** As ações do Bison geram o código JavaScript correspondente, escrevendo-o no arquivo de saída (`saida.js`).

## 4. Gramática (EBNF) da PixelScript

A gramática da PixelScript é definida da seguinte forma:

```ebnf
<programa>      ::= { <comando> }

<comando>       ::= <comando_desenho> | <comando_logica> | <comando_atribuicao>

<comando_desenho> ::= "CANVAS" <expr> "," <expr>
                    | "COR" <expr> "," <expr> "," <expr>
                    | "PONTO"
                    | "MOVER" <expr> "," <expr>
                    | "LINHA" <expr> "," <expr>
                    | "RETANGULO" <expr> "," <expr>

<comando_logica> ::= <comando_se> | <comando_repetir>

<comando_se>    ::= "SE" <condicao> "{" <bloco> "}" [ "SENAO" "{" <bloco> "}" ]

<comando_repetir> ::= "REPETIR" <expr> "VEZES" "{" <bloco> "}"

<comando_atribuicao> ::= "VAR" <id> "=" <expr>
                       | <id> "=" <expr>

<bloco>         ::= { <comando> }

<condicao>      ::= <expr> <op_comp> <expr>

<expr>          ::= <id> | <valor> | <expr> <op_arit> <expr> | "(" <expr> ")"

<op_comp>       ::= "==" | "!=" | ">" | "<" | ">=" | "<="
<op_arit>       ::= "+" | "-" | "*" | "/"
<id>            ::= [a-zA-Z_][a-zA-Z0-9_]*
<valor>         ::= -?[0-9]+
```

## 5. Exemplo de Teste (fibonacci.pixel)

O script `fibonacci.pixel` demonstra o uso de todas as estruturas da linguagem para desenhar uma Espiral de Arquimedes.

### Código PixelScript

```pixelscript
// =======================================================
// Desenho Showcase: Espiral de Arquimedes com Linhas (v1.0)
// Demonstra o comando LINHA e a lógica de giro.
// =======================================================

VAR tamanho_canvas = 1000
CANVAS tamanho_canvas, tamanho_canvas

// --- Configuração Inicial ---
VAR centro_x = tamanho_canvas / 2
VAR centro_y = tamanho_canvas / 2
VAR x = centro_x
VAR y = centro_y
MOVER x, y // Inicia a caneta no centro

VAR escala = tamanho_canvas / 50
VAR direcao = 0
VAR passos = 1
VAR contador_passos = 0
VAR contador_giros = 0

// --- Loop Principal ---
REPETIR 100 VEZES {
    
    // Define a cor baseada na direção atual
    SE direcao == 0 { COR 255, 0, 0 } // Vermelho (Direita)
    SENAO {
        SE direcao == 1 { COR 0, 255, 0 } // Verde (Cima)
        SENAO {
            SE direcao == 2 { COR 0, 0, 255 } // Azul (Esquerda)
            SENAO {
                SE direcao == 3 { COR 255, 165, 0 } // Laranja (Baixo)
            }
        }
    }
    
    // Calcula o próximo ponto
    VAR proximo_x = x
    VAR proximo_y = y
    
    SE direcao == 0 { proximo_x = x + (passos * escala) } // Direita
    SENAO {
        SE direcao == 1 { proximo_y = y - (passos * escala) } // Cima
        SENAO {
            SE direcao == 2 { proximo_x = x - (passos * escala) } // Esquerda
            SENAO {
                SE direcao == 3 { proximo_y = y + (passos * escala) } // Baixo
            }
        }
    }
    
    // Desenha a linha para o próximo ponto
    LINHA proximo_x, proximo_y
    
    // Atualiza a posição da caneta para o final da linha
    x = proximo_x
    y = proximo_y
    MOVER x, y

    // Lógica de giro
    direcao = direcao + 1
    SE direcao > 3 {
        direcao = 0
    }
    
    contador_giros = contador_giros + 1
    SE contador_giros == 2 {
        passos = passos + 1
        contador_giros = 0
    }
}

```

## 6. Como Compilar e Executar

1.  **Compilação:** Certifique-se de que `flex` e `bison` estão instalados.
    ```bash
    bison -d -o parser.tab.c parser.y
    gcc -Wall -Wno-unused-function -c -o parser.tab.o parser.tab.c
    flex -o lexer.c lexer.l
    gcc -Wall -Wno-unused-function -c -o lexer.o lexer.c
    gcc -o pixelscript parser.tab.o lexer.o
    ```
2.  **Execução:** Compile o código PixelScript para JavaScript.
    ```bash
    ./pixelscript saida.js < fibonacci.pixel
    ```
3.  **Visualização:** Abra o arquivo `template.html` (que carrega `saida.js`) em qualquer navegador.
