# Project: lab02
# Makefile

CPP  = g++
CC   = gcc -Wall -g
WINDRES = windres.exe
RES  = 
OBJ  = log.o utils.o mem.o io.o bundle.o hashmap.o aluno.o lab02.o $(RES)
LINKOBJ  = log.o utils.o mem.o io.o bundle.o hashmap.o aluno.o lab02.o  $(RES)
LIBS =   
INCS = 
CXXINCS = 
BIN  = lab01b
CXXFLAGS = $(CXXINCS)  
CFLAGS = $(INCS)  
RM = rm -f

.PHONY: all all-before all-after clean clean-custom

all: all-before lab01b all-after

clean: clean-custom
	${RM} $(OBJ) $(BIN)

$(BIN): $(OBJ)
	$(CC) $(LINKOBJ) -o "lab02" -g $(LIBS)
	
mem.o: mem.c
	$(CC)  -c mem.c -o mem.o $(CFLAGS)

log.o: log.c
	$(CC)  -c log.c -o log.o $(CFLAGS)

utils.o: utils.c
	$(CC)  -c utils.c -o utils.o $(CFLAGS)

io.o: io.c
	$(CC)  -c io.c -o io.o $(CFLAGS)

bundle.o: bundle.c
	$(CC)  -c bundle.c -o bundle.o $(CFLAGS)

hashmap.o: hashmap.c
	$(CC) -c hashmap.c -o hashmap.o $(CFLAGS)

aluno.o: aluno.c
	$(CC) -c aluno.c -o aluno.o $(CFLAGS)

lab02.o: lab02.c
	$(CC) -c lab02.c -o lab02.o $(CFLAGS)
	
