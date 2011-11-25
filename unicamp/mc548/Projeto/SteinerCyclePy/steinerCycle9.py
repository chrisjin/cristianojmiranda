import sys, itertools, math, random
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

from pygraph.algorithms.heuristics.euclidean import *
from pygraph.algorithms.accessibility import *
from pygraph.algorithms.critical import *
from pygraph.algorithms.minmax import *

class Steiner9(Thread):

	time = 0;
	result = [];
	
	def run(self):
		logDebug("Thread Steiner9 running...", __name__);
		self.result = self.steinerCycle9();
		logDebug("Thread Steiner9 finished", __name__);

	# --
	def steinerCycle9(self):
		
		# Ciclo
		ciclo = [];
		
		# Obtem a lista de terminais embaralhada
		term = list(terminais);
		random.shuffle(term);
		
		logDebug("Terminais: " + str(term), __name__);
		
		# Criando um novo grafo
		g = getGraph();
		
		while len(term) > 1:
		
			logDebug("Ciclo: " + str(ciclo), __name__);
		
			# Verifica timeout
			if (time() - self.time) >= getTimeOut():
				logDebug("Timeout", __name__);
				break;
		
			va = term.pop();
			vb = term.pop();
		
			# Executa busta em profundidade
			st, pre, post = depth_first_search(g, root=va)
			logDebug("ST: " + str(st) + ", PRE: " + str(pre) + ", POST: " + str(post), __name__);
			
			# Caso exista um caminho entre os verties
			if findItemList(pre, vb) >= 0:
			
				ciclo.append(va);
				
				while va != vb:
				
					# Verifica timeout
					if (time() - self.time) >= getTimeOut():
						logDebug("Timeout", __name__);
						break;
					
					# Vertices adjacentes
					adj = adjVertices[va];
					
					# Obtem a menor aresta
					mnAresta = findMenorAresta(va, adj, ciclo, True);
					logDebug("Menor aresta de " + str(va) + ": " + str(mnAresta), __name__);
					
					if mnAresta == None:
						break;
						
					elif findItemList(ciclo, mnAresta[1]) >= 0:
					
						if va == mnAresta[0]:					
							va = mnAresta[1];
						elif va == mnAresta[1]:
							va = mnAresta[0];
					
						ciclo.append(va);
				
			else:
				term.append(va);
				term.append(vb);
			
		if len(term) > 0:
			ciclo.append(term[0]);
			
		logDebug("Ciclo: " + str(ciclo), __name__);
		
		# caso o ciclo nao esteja completo
		if not existeCiclo(ciclo):
		
			# Executa busta em profundidade
			st, pre, post = depth_first_search(g, root=ciclo[len(ciclo)-1])
			logDebug("ST: " + str(st) + ", PRE: " + str(pre) + ", POST: " + str(post), __name__);
			
			# Caso seja alcancavel
			if findItemList(pre, ciclo[0]) >= 0:
				d = 0;
		
		
		
		# Caso exista o ciclo
		if existeCiclo(ciclo) and containTerminais(ciclo):
			return ['Y', computaCiclo(ciclo), ciclo, time() - self.time, 'Steiner9'];
		
		return ['N', 0, [], time() - self.time, 'Steiner9'];