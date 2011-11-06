###############################################################################
# Author: Carlos Eduardo de Andrade <andrade@ic.unicamp.br>
#
# (c) Copyright 2011 Institute of Computing, University of Campinas.
#     All Rights Reserved.
#
#  Created on : Oct 02, 2011 by andrade
#  Last update: Oct 02, 2011 by andrade
#
# This software is licensed under the Common Public License. Please see
# accompanying file for terms.
###############################################################################

#!!! COLOQUE AQUI O NOME DA LIB QUE SER� GERADA A PARTIR DE SEU C�DIGO
#!!! MODIFIQUE APENAS SEU RA
OBJLIB = ../libRA083382.a

#!!! COLOQUE AQUI TODOS OS ARQUIVOS-OBJETOS QUE SER�O GERADOS POR SEUS FONTES
OBJS = RA083382.o algExato.o heuristicas.o

###############################################################################
# Minhas flags/includes/libs locais. Altere somente se necess�rio.
###############################################################################

# inclui flags originais
include ../Makefile.inc

# Altera ou acrescenta outra flags
#CXXFLAGS += xxxx

# Necessary Include dirs
#INCLUDES += xxxx

###############################################################################

.SUFFIXES: .cpp .o

all: $(OBJLIB)

$(OBJLIB): $(OBJS)
	@echo
	@echo "--> ar rv $(OBJLIB) $?"
	$(AR) rv $(OBJLIB) $?
	@echo
	@echo "--> ranlib $(OBJLIB)"
	$(RANLIB) $(OBJLIB)
	@echo 

.cpp.o:
	@echo "--> Compiling $<..."
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(USER_DEFINES) -c $< -o $@
	@echo

clean:
	$(RM) -f $(OBJS)

force_look :
	true