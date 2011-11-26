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

# Steiner9 - Executa aleatoriamente trocando os valores de um vetor e verificando se existe um ciclo valido
# ate acontecer timeout ou nao haver mais vertices para serem processados.
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
		ciclo = list(terminais)
		random.shuffle(ciclo);
		random.shuffle(ciclo);
		random.shuffle(ciclo);
		
		# Obtem os vertices nao terminais
		nt = list(set(vertices) - set(terminais));
		random.shuffle(nt);
		random.shuffle(nt);
		
		while True:
		
			# Verifica timeout
			if (time() - self.time) >= getTimeOut():
				logDebug("Timeout", __name__);
				break;
		
			vi = False;
			if len(nt) > 0:
				vi = nt[random.randint(0, len(nt)-1)];
				logDebug("Chutando um vertice: " + str(vi), __name__);
			
			if existeCiclo(ciclo):
				logDebug("Ops! Encontrou o ciclo:" + str(ciclo), __name__);
				return ['Y', computaCiclo(ciclo), ciclo, time() - self.time, 'Steiner9'];
		
			if len(nt) == 0:
				break;
				
			
			if vi and random.randint(0, 10) == 1:
				nt.remove(vi);
				ciclo.append(vi);
				
				
			random.shuffle(ciclo);
			
		
		return ['N', 0, [], time() - self.time, 'Steiner9'];