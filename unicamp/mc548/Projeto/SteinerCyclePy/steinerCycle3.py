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

class Steiner3(Thread):
	result = [];
	def run(self):
		logDebug("Thread Steiner3 running...");
		self.result = steinerCycle3();
		logDebug("Thread Steiner3 finished");

		
def tentaVizinhoMaisProximoMinimo(tempo, ciclo):
	
	logInfo("Tentando colocar os vizinhos mais proximos...");
	
	if len(ciclo) == 0:	
		return ['N', 0, [], time() - t, 'Steiner3'];
	
	# Monta uma lista com os terminais que nao estao no ciclo
	diff = [];
	for t in terminais:
		if findItemList(ciclo, t) == -1:
			diff.append(t);
			
	logDebug("Terminais faltantes: " + str(diff));
	
	# Tenta encaixar os terminais
	for t in diff:
	
		# Verificando timeout
		logDebug("Verificando timeout. limit: " + str(getTimeOut()) + ", atual: " + str(time() - tempo) );
		if (time() - tempo) >= getTimeOut():
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
	
	# existe um ciclo, porem existem nos a mais
	if containTerminais(ciclo) and len(ciclo) > len(terminais):
		logDebug("Tentando remover os nos que nao fazem parte dos terminais...");
		
		# Computando os nos nao terminais
		nTerminais = []
		for n in ciclo:
			if findItemList(terminais, n) == -1:
				nTerminais.append(n);
				
		logDebug("Nos nao terminais: " + str(nTerminais));
		
		# Remove os nos nao terminais
		for nt in nTerminais:
			ciclo.remove(nt);
			
		# Verifica se ainda existe um ciclo
		for i in range(len(ciclo)):
			va = -1
			vb = -1
			if i < len(ciclo) - 1:
				va = ciclo[i]
				vb = ciclo[i+1]
			else:
				va = ciclo[i]
				vb = ciclo[0]
				
			if findItemList(adjVertices[va], vb) == -1:
				return ['N', 0, [], time() - tempo, 'Steiner3']
	
	if containTerminais(ciclo):
		return ['Y', computaCiclo(ciclo), ciclo, time() - tempo, 'Steiner3'];
		
	return ['N', 0, [], time() - tempo, 'Steiner3']
			
	
		
# --
def steinerCycle3():
	t = time();
	
	# Obtem um ciclo
	cycle = find_cycle(getGraph())
	logDebug("Ciclo: " + str(cycle));
	
	# Verifica se contain todos os terminais no ciclo
	if containTerminais(cycle):
		return ['Y', computaCiclo(cycle), cycle, time() - t, 'Steiner3'];
	else:
		return tentaVizinhoMaisProximoMinimo(t, cycle)

		