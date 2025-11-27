/* parser.y - VERSÃO FINAL ROBUSTA (corrige conflito shift/reduce) */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(char const *s);
FILE *output_file; 

// Função auxiliar para gerar o código JS a partir dos comandos
char* generate_command_js(const char* cmd, const char* p1, const char* p2, const char* p3) {
    char* temp_str = NULL;

    if (strcmp(cmd, "CANVAS") == 0) {
        asprintf(&temp_str, "const canvas = document.getElementById('pixelCanvas');\nconst ctx = canvas.getContext('2d');\ncanvas.width = %s;\ncanvas.height = %s;\npen_thickness = Math.max(1, Math.floor(canvas.width * 0.01));\n", p1, p2);
    } else if (strcmp(cmd, "MOVER") == 0) {
        asprintf(&temp_str, "pen_x = %s;\npen_y = %s;\n", p1, p2);
    } else if (strcmp(cmd, "LINHA") == 0) {
        asprintf(&temp_str, "ctx.beginPath(); ctx.lineWidth = pen_thickness; ctx.strokeStyle = ctx.fillStyle; ctx.moveTo(pen_x, pen_y); ctx.lineTo(%s, %s); ctx.stroke();\npen_x = %s;\npen_y = %s;\n", p1, p2, p1, p2);
    } else if (strcmp(cmd, "RETANGULO") == 0) {
        asprintf(&temp_str, "ctx.fillRect(pen_x, pen_y, %s, %s);\n", p1, p2);
    } else if (strcmp(cmd, "COR") == 0) {
        asprintf(&temp_str, "ctx.fillStyle = `rgb(%s, %s, %s)`;\n", p1, p2, p3);
    } else if (strcmp(cmd, "PONTO") == 0) {
        asprintf(&temp_str, "ctx.fillRect(pen_x, pen_y, pen_thickness, pen_thickness);\n");
    } else if (strcmp(cmd, "VAR") == 0) {
        asprintf(&temp_str, "let %s = %s;\n", p1, p2);
    }
    
    // Garante que a função nunca retorne NULL
    if (temp_str == NULL) {
        return strdup("");
    }
    return temp_str;
}

%}

/* --- Declarações de Tipos e Tokens --- */
%union { char *sval; }

%token <sval> TOKEN_PALAVRA_CHAVE
%token <sval> TOKEN_VALOR
%token <sval> TOKEN_OPERADOR_COMP

%left '+' '-'
%left '*' '/'
%right '='
%left TOKEN_OPERADOR_COMP

%type <sval> expressao
%type <sval> condicao
%type <sval> comando
%type <sval> bloco_comandos
%type <sval> comando_fechado
%type <sval> comando_aberto
%type <sval> comando_nao_se

%%

/* --- Regras da Gramática --- */

// A regra principal do programa
programa:
    %empty 
    | programa comando { 
        if ($2 != NULL && strlen($2) > 0) { fprintf(output_file, "%s", $2); }
        free($2); 
    }
    ;

// Um bloco de comandos entre chaves, retorna todo o JS como uma única string
bloco_comandos:
    %empty { $$ = strdup(""); }
    | bloco_comandos comando { asprintf(&$$, "%s%s", $1, $2); free($1); free($2); }
    ;

// --- NOVA ESTRUTURA DE COMANDOS PARA RESOLVER AMBIGUIDADE ---
comando:
    comando_fechado { $$ = $1; }
    | comando_aberto  { $$ = $1; }
    ;

// Comandos que não podem ser estendidos (não terminam com um SE sem SENAO)
comando_fechado:
    comando_nao_se { $$ = $1; }
    | TOKEN_PALAVRA_CHAVE condicao '{' bloco_comandos '}' TOKEN_PALAVRA_CHAVE '{' bloco_comandos '}' { // SE-SENAO
        char* temp_str = NULL;
        if (strcmp($1, "SE") == 0 && strcmp($6, "SENAO") == 0) {
            asprintf(&temp_str, "if (%s) {\n%s} else {\n%s}\n", $2, $4, $8);
        }
        $$ = (temp_str) ? temp_str : strdup("");
        free($1); free($2); free($4); free($6); free($8);
    }
    ;

// Comandos que podem ser estendidos (terminam com um SE sem SENAO)
comando_aberto:
    TOKEN_PALAVRA_CHAVE condicao '{' bloco_comandos '}' { // SE sozinho
        char* temp_str = NULL;
        if (strcmp($1, "SE") == 0) {
            asprintf(&temp_str, "if (%s) {\n%s}\n", $2, $4);
        }
        $$ = (temp_str) ? temp_str : strdup("");
        free($1); free($2); free($4);
    }
    ;

// Todos os outros comandos que não são 'SE'
comando_nao_se:
    TOKEN_PALAVRA_CHAVE expressao ',' expressao { $$ = generate_command_js($1, $2, $4, NULL); free($1); free($2); free($4); }
    | TOKEN_PALAVRA_CHAVE expressao ',' expressao ',' expressao { $$ = generate_command_js($1, $2, $4, $6); free($1); free($2); free($4); free($6); }
    | TOKEN_PALAVRA_CHAVE { $$ = generate_command_js($1, NULL, NULL, NULL); free($1); }
    | TOKEN_PALAVRA_CHAVE TOKEN_VALOR '=' expressao { $$ = generate_command_js($1, $2, $4, NULL); free($1); free($2); free($4); }
    | TOKEN_VALOR '=' expressao { asprintf(&$$, "%s = %s;\n", $1, $3); free($1); free($3); }
    | TOKEN_PALAVRA_CHAVE expressao TOKEN_PALAVRA_CHAVE '{' bloco_comandos '}' { // REPETIR
        char* temp_str = NULL;
        if (strcmp($1, "REPETIR") == 0 && strcmp($3, "VEZES") == 0) {
            asprintf(&temp_str, "for (let _i = 0; _i < %s; _i++) {\n%s}\n", $2, $5);
        }
        $$ = (temp_str) ? temp_str : strdup("");
        free($1); free($2); free($3); free($5);
    }
    ;

condicao: expressao TOKEN_OPERADOR_COMP expressao { asprintf(&$$, "%s %s %s", $1, $2, $3); free($1); free($2); free($3); };
expressao: TOKEN_VALOR { $$ = $1; } | expressao '+' expressao { asprintf(&$$, "(%s + %s)", $1, $3); free($1); free($3); } | expressao '-' expressao { asprintf(&$$, "(%s - %s)", $1, $3); free($1); free($3); } | expressao '*' expressao { asprintf(&$$, "(%s * %s)", $1, $3); free($1); free($3); } | expressao '/' expressao { asprintf(&$$, "(%s / %s)", $1, $3); free($1); free($3); } | '(' expressao ')' { asprintf(&$$, "(%s)", $2); free($2); };

%%

/* --- Código C Auxiliar --- */

// Função principal que inicia o processo
int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <arquivo_de_saida.js>\n", argv[0]);
        return 1;
    }
    output_file = fopen(argv[1], "w");
    if (!output_file) {
        perror("Não foi possível abrir o arquivo de saída");
        return 1;
    }
    
    // Escreve o cabeçalho do arquivo JavaScript
    fprintf(output_file, "// Arquivo gerado pelo compilador PixelScript (vFinal Robusta)\n\n");
    fprintf(output_file, "let pen_x = 0; let pen_y = 0; let pen_thickness = 1;\n\n");
    
    // Inicia a análise
    yyparse();
    
    // Escreve o rodapé do arquivo
    fprintf(output_file, "\nconsole.log('Execução do PixelScript finalizada.');\n");
    fclose(output_file);
    printf("Arquivo '%s' gerado com sucesso.\n", argv[1]);
    return 0;
}

// Função de tratamento de erros chamada pelo Bison
void yyerror(char const *s) {
    fprintf(stderr, "Erro de sintaxe. Verifique seu código PixelScript.\n");
}
