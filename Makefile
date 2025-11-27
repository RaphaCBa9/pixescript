# Makefile para o Compilador PixelScript (Flex/Bison)

# Variáveis
CC = gcc
CFLAGS = -Wall -Wno-unused-function
LDFLAGS = -lfl # Linka com a biblioteca flex (libfl)
TARGET = pixelscript
SOURCES = parser.y lexer.l
OBJECTS = parser.tab.o lexer.o

# Regra principal: compila tudo
all: $(TARGET)

# Regra para o executável final
$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $(TARGET) $(LDFLAGS)

# Regra para gerar o parser.tab.c e parser.tab.h a partir do parser.y
parser.tab.c parser.tab.h: parser.y
	bison -d -o parser.tab.c parser.y

# Regra para compilar o parser.tab.c
parser.tab.o: parser.tab.c
	$(CC) $(CFLAGS) -c parser.tab.c

# Regra para gerar o lexer.c a partir do lexer.l
lexer.c: lexer.l parser.tab.h
	flex -o lexer.c lexer.l

# Regra para compilar o lexer.c
lexer.o: lexer.c
	$(CC) $(CFLAGS) -c lexer.c

# Regra de limpeza
clean:
	rm -f $(TARGET) $(OBJECTS) parser.tab.c parser.tab.h lexer.c saida.js

# Evita que o make tente procurar por arquivos com o mesmo nome das regras
.PHONY: all clean
