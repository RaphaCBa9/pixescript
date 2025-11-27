%{
#include "parser.tab.h" 
#include <string.h>
#define YY_INPUT(buf, result, max_size) (result = fread(buf, 1, max_size, yyin))
%}

%option noyywrap

%%

"CANVAS"    |
"COR"       |
"PONTO"     |
"MOVER"     |
"LINHA"     |
"RETANGULO" |
"VAR"       |
"SE"        |
"SENAO"     |
"REPETIR"   |
"VEZES"     { yylval.sval = strdup(yytext); return TOKEN_PALAVRA_CHAVE; }

-?[0-9]+    { yylval.sval = strdup(yytext); return TOKEN_VALOR; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return TOKEN_VALOR; }

"=="        |
"!="        |
">"         |
"<"         |
">="        |
"<="        { yylval.sval = strdup(yytext); return TOKEN_OPERADOR_COMP; }

"="         { return '='; }
","         { return ','; }
"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"("         { return '('; }
")"         { return ')'; }
"{"         { return '{'; }
"}"         { return '}'; }

[ \t\n]+    { }
"//".*      { }

.           { printf("Caractere desconhecido: %c\n", *yytext); }

%%
