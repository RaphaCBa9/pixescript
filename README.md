# PixelScript: Linguagem de Programação para Desenho Procedural

## Introdução

Este projeto consiste na criação de uma linguagem de programação de alto nível chamada **PixelScript** para desenhos procedurais, desenvolvida para interagir com um navegador através de uma tag `<Canvas>` HTML, isso é feito a partir de um arquivo JavaScript gerado pela linguagem. O objetivo principal foi demonstrar a aplicação prática de conceitos de Análise Léxica e Sintática, utilizando as ferramentas padrão de mercado **Flex** e **Bison**.

## Objetivos

| Objetivo | Detalhes |
| :--- | :--- |
| **Criar uma Linguagem de Programação** | A linguagem PixelScript foi criada com foco em desenho procedural. |
| **Estruturas Básicas (Variáveis, Condicionais, Loops)** | Implementação de `VAR`, `SE...SENAO` e `REPETIR...VEZES`. |
| **Análise Léxica e Sintática (Flex/Bison)** |  O compilador `pixelscript` foi desenvolvido usando Flex e Bison para gerar código C, que por sua vez gera o arquivo JavaScript da para interação com o HTML. |
| **Utilizar uma VM** | O código é interpretado pelo motor JavaScript do navegador (VM). |
| **Criar um Exemplo de Teste** | O script `fibonacci.pixel` demonstra o uso de todas as estruturas. |

## Processo de compilação

O compilador `pixelscript` funciona em três etapas:

1.  **Análise Léxica com Flex:** O arquivo `lexer.l` lê o código-fonte da PixelScript e o transforma em *tokens* (palavras-chave, identificadores, valores, operadores).
2.  **Análise Sintática com Bison:** O arquivo `parser.y` recebe os tokens e verifica se a sequência obedece à gramática (EBNF). Ações C/C++ são executadas para cada regra sintática reconhecida.
3.  **Geração de Código (C):** As ações do Bison geram o código JavaScript correspondente, escrevendo-o no arquivo de saída (`saida.js`).

## EBNF da PixelScript

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


## Como Compilar e Executar

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
    ./pixelscript saida.js < seu_script.pixel
    ```
    Este comando gerará um arquivo `saida.js`
    
3.  **Visualização:** Abra um arquivo `.html` que contenha uma tag `<Canvas>` com `id="pixelCanvas"`, e uma self-closing tag `<script>` que carrega `saida.js`, com `src="saida.js"`, isso pode ser feito em qualquer navegador.

   Exemplo de `template.html`:
   ```html
  <!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Resultado do PixelScript</title>
    <style>
        body { background-color: #333; display: flex; justify-content: center; align-items: center; height: 100vh; }
        canvas { background-color: #fff; border: 2px solid #555; image-rendering: pixelated; }
    </style>
</head>
<body style="flex-direction: column;">
    <div>
        <h1 style="color: whitesmoke;">Seu Desenho PixelScript</h1>
    </div>

    <div>
        <canvas id="pixelCanvas"></canvas>
    </div>

    <script src="saida.js"></script>
</body>
</html>
```
