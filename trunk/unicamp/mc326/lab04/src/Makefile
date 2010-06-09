# Project: lab04
# Makefile

CPP  = g++
CC   = gcc -Wall -g
WINDRES = windres.exe
RES  = 
OBJ  = log.o utils.o mem.o io.o bundle.o hashmap.o mylist.o aluno.o lab04.o $(RES)
LINKOBJ  = log.o utils.o mem.o io.o bundle.o hashmap.o  mylist.o aluno.o lab04.o  $(RES)
LIBS =   
INCS = 
CXXINCS = 
BIN  = lab04
CXXFLAGS = $(CXXINCS)  
CFLAGS = $(INCS)  
RM = rm -f

.PHONY: all all-before all-after clean clean-custom

all: all-before lab01b all-after

clean: clean-custom
	${RM} $(OBJ) $(BIN)

$(BIN): $(OBJ)
	$(CC) $(LINKOBJ) -o "lab04" -g $(LIBS)
	
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

mylist.o: mylist.c
	$(CC) -c mylist.c -o mylist.o $(CFLAGS)

aluno.o: aluno.c
	$(CC) -c aluno.c -o aluno.o $(CFLAGS)

lab04.o: lab04.c
	$(CC) -c lab04.c -o lab04.o $(CFLAGS)
	
