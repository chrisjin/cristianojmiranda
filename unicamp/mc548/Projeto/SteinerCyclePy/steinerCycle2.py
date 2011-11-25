import sys, itertools, math
from operator import itemgetter, attrgetter
from time import time
from threading import Thread
from pygraph.classes.graph import graph
from pygraph.classes.digraph import digraph
from pygraph.algorithms.searching import *
from pygraph.readwrite.dot import write
from pygraph.algorithms.cycles import *
from collectionUtils import *
from graphUtils import *
from logger import *

class Steiner2(Thread):
	result = [];
	time = 0;
	
	def run(self):
		logDebug("Thread Steiner2 running...");
		self.result = self.steinerCycle2();
		logDebug("Thread Steiner2 finished");

		
	def tentaVizinhoMaisProximo(self, ciclo):
		
		logInfo("Tentando colocar os vizinhos mais proximos...");
		
		if len(ciclo) == 0:	
			return ['N', 0, [], time() - self.time, 'Steiner2'];
		
		# Monta uma lista com os terminais que nao estao no ciclo
		diff = [];
		for t in terminais:
			if findItemList(ciclo, t) == -1:
				diff.append(t);
				
			# Verificando timeout
			logDebug("Verificando timeout. limit: " + str(getTimeOut()) + ", atual: " + str(time() - self.time) );
			if (time() - self.time) >= getTimeOut():
				logDebug("Timeout!");
				break;
				
		logDebug("Terminais faltantes: " + str(diff));
		
		# Tenta encaixar os terminais
		for t in diff:
		
			# Verificando timeout
			logDebug("Verificando timeout. limit: " + str(getTimeOut()) + ", atual: " + str(time() - self.time) );
			if (time() - self.time) >= getTimeOut():
				logDebug("Timeout!");
				break;
		
			for i in range(len(ciclo)):
				va = -1;
				vb = -1;
				if i < len(ciclo) - 1:
					va = ciclo[i];
					vb = ciclo[i+1];
				else:
					va = ciclo[0];
					vb = ciclo[i];
					
				logDebug("Adj de " + str(t) + " ==> " + str(adjVertices[t]));
				logDebug("Va=" + str(va) + ", Vb=" + str(vb));
				# Tenta encaixar o terminal entre os vertices do ciclo
				if findItemList(adjVertices[t], va) >= 0 and findItemList(adjVertices[t], vb) >= 0:
					ciclo.insert(i+1, t);
					break;
		
		logDebug("Novo ciclo: " + str(ciclo));
		
		if containTerminais(ciclo):
			return ['Y', computaCiclo(ciclo), ciclo, time() - self.time, 'Steiner2'];
		
		
		return ['N', 0, [], time() - self.time, 'Steiner2'];
				
		
			
	# --
	def steinerCycle2(self):
		
		# Obtem um ciclo
		cycle = find_cycle(getGraph())
		logDebug("Ciclo: " + str(cycle));
		
		# Verifica se contain todos os terminais no ciclo
		if len(cycle) > 0 and containTerminais(cycle):
			return ['Y', computaCiclo(cycle), cycle, time() - self.time, 'Steiner2'];
		else:
			return self.tentaVizinhoMaisProximo(cycle)