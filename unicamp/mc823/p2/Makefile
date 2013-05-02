# Project: mc823-S2013-p1 - MiniAmazon
# Makefile

CPP  = g++
CC   = gcc -Wall -g -ggdb
WINDRES = windres.exe
RES  = 
OBJ  = mem.o io.o utils.o controleacesso.o amazonservice.o server.o client.o main.o $(RES)
LINKOBJ  = mem.o io.o utils.o controleacesso.o amazonservice.o server.o client.o main.o  $(RES)
LIBS =   
INCS = 
CXXINCS = 
BIN  = mc823-S2013-p1
CXXFLAGS = $(CXXINCS)  
CFLAGS = $(INCS)  
RM = rm -f

.PHONY: all all-before all-after clean clean-custom

all: all-before mc823-S2013-p1 all-after

clean: clean-custom
	${RM} $(OBJ) $(BIN)

$(BIN): $(OBJ)
	$(CC) $(LINKOBJ) -o "mc823-S2013-p1-ra083382" -g $(LIBS)
        
mem.o: mem.c
	$(CC)  -c mem.c -o mem.o $(CFLAGS)

io.o: io.c
	$(CC)  -c io.c -o io.o $(CFLAGS)	
	
utils.o: utils.c
	$(CC)  -c utils.c -o utils.o $(CFLAGS)
	
controleacesso.o: controleacesso.c
	$(CC) -c controleacesso.c -o controleacesso.o $(CFLAGS)
        
amazonservice.o: amazonservice.c
	$(CC) -c amazonservice.c -o amazonservice.o $(CFLAGS)

server.o: server.c
	$(CC) -c server.c -o server.o $(CFLAGS)
	
client.o: client.c
	$(CC) -c client.c -o client.o $(CFLAGS)	
	
main.o: main.c
	$(CC) -c main.c -o main.o $(CFLAGS)