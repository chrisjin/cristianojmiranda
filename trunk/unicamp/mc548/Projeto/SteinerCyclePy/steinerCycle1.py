import sys, itertools, math
from time import time
from threading import Thread
from operator import itemgetter, attrgetter
from collectionUtils import *
from graphUtils import *
from logger import *

class Steiner1(Thread):
	result = [];
	def run(self):
		logDebug("Thread Steiner1 running...");
		self.result = steinerCycle1();
		
	

#-- Computa o ciclo apenas nos terminais
def cicloTerminais():
	
	logInfo("\n\nINICIO cicloTerminais");
	
	ciclo = [];
	
	for i in terminais:
	
		logDebug("Processando node: " + str(i));
	
		aresta = (-1, -1);
		if len(ciclo) == 0:
			aresta = findMenorAresta(i, terminais, ciclo, True);
		else:
			exclude = []
			if len(ciclo) != len(terminais):
				exclude = ciclo;
			aresta = findMenorAresta(ciclo[len(ciclo) - 1],  terminais, exclude, True);
			
		if aresta != (-1, -1):
			if findItemList(ciclo, aresta[1]) == -1:
				ciclo.append(aresta[1]);
			if findItemList(ciclo, aresta[0]) == -1:
				ciclo.append(aresta[0]);
			
					
	# Verifica se existe mesmo o ciclo ligando o ultimo e o primeiro vertice
	aresta = findMenorAresta(ciclo[len(ciclo)-1], [ciclo[0]], [], False);
	
	logInfo("FIM cicloTerminais\n\n");
	if aresta != (-1, -1) and len(ciclo) >= len(terminais):
		return ['Y', computaCiclo(ciclo), ciclo];
	else:
		return ['N', 0, []];
	


#-- Processa o ciclo
def steinerCycle1():
	t = time();
	result = cicloTerminais();
	result.append(time() - t);
	result.append('Steiner1');
	return result;