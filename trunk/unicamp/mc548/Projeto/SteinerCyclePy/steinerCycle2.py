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

gr = graph();

class Steiner2(Thread):
	result = [];
	def run(self):
		logDebug("Thread Steiner2 running...");
		self.result = steinerCycle2();
		logDebug("Thread Steiner2 finished");

# --
def steinerCycle2():
	t = time();
	global gr;
		
	# Criando o grafo
	gr = graph()
	
	# Adicionando os vertices
	gr.add_nodes(vertices)
	
	# Adicionando as arestas
	for key in arestas.iterkeys():
		gr.add_edge(key);
	
	# Obtem um ciclo
	cycle = find_cycle(gr)
	
	if containTerminais(cycle):
		return ['Y', computaCiclo(cycle), cycle, time() - t, 'Steiner2'];
	else:
		return ['N', 0, [], time() - t, 'Steiner2'];

		