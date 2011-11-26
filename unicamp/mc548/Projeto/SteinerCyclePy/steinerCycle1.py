import sys, itertools, math
from time import time
from threading import Thread
from operator import itemgetter, attrgetter
from collectionUtils import *
from graphUtils import *
from logger import *

# Algotimo implementa "Vizinho mais proximo para os terminais"
# Steiner 1 - Tem encontrar um ciclo que conecta
# exatamente todos os terminais do grafo (considerando o arestas de menor custo)
class Steiner1(Thread):
	
	result = [];
	time = 0;
	
	def run(self):
		logDebug("Thread Steiner1 running...");
		self.result = self.steinerCycle1();
		logDebug("Thread Steiner1 finished");
		
	

	#-- Computa o ciclo apenas nos terminais
	def cicloTerminais(self):
		
		logInfo("\n\nINICIO cicloTerminais");
		
		ciclo = [];
		
		# Itera nos terminais verificando arestas de menor custo e tenta fechar o ciclo
		for i in terminais:
		
			logDebug("Processando node: " + str(i), __name__);
			
			# Valida timeout
			if (time() - self.time) >= getTimeOut():
				logDebug("Timeout");
				return ['N', 0, []];
		
			# Tenta obter a aresta de menor custo
			aresta = (-1, -1);
			if len(ciclo) == 0:
				# Caso nao exista vertices no ciclo considera o primeiro terminal da lista
				aresta = findMenorAresta(i, terminais, ciclo, True);
			else:
				# Existe vertices no ciclo, entao pega o ultimo vertice adicionado
				exclude = []
				if len(ciclo) != len(terminais):
					exclude = ciclo;
				aresta = findMenorAresta(ciclo[len(ciclo) - 1],  terminais, exclude, True);
				
			vAtual = 1
			vProxi = 0
			if aresta != None:
				if len(ciclo) == 0:
					if i == aresta[0]:
						vAtual = 0
						vProxi = 1
				elif ciclo[len(ciclo) - 1] == aresta[0]:
					vAtual = 0;
					vProxi = 1;
				
				if findItemList(ciclo, aresta[vAtual]) == -1:
					ciclo.append(aresta[vAtual]);
				if findItemList(ciclo, aresta[vProxi]) == -1:
					ciclo.append(aresta[vProxi]);
					
		# Verifica se existe mesmo o ciclo ligando o ultimo e o primeiro vertice
		aresta = None;
		if len(ciclo) > 0:
			aresta = findMenorAresta(ciclo[len(ciclo)-1], [ciclo[0]], [], True);
		
		logInfo("FIM cicloTerminais\n\n");
		if aresta != None and len(ciclo) >= len(terminais):
			return ['Y', computaCiclo(ciclo), ciclo];
		else:
			return ['N', 0, []];
		


	#-- Processa o ciclo
	def steinerCycle1(self):
		result = self.cicloTerminais();
		result.append(time() - self.time);
		result.append('Steiner1');
		return result;