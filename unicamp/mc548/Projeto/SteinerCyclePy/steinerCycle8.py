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

class Steiner8(Thread):

	time = 0;
	result = [];
	
	def run(self):
		logDebug("Thread Steiner8 running...", __name__);
		self.result = self.steinerCycle8();
		logDebug("Thread Steiner8 finished", __name__);

	# --
	def steinerCycle8(self):
		
		# Criando um novo grafo
		g = graph()
		
		# Adicionando os vertices
		g.add_nodes(vertices)
		
		# Adicionando os positons (necessarios para euclidean)
		for i in range(len(vertices)):
			g.add_node_attribute(vertices[i], ('position',(0, i)))
		
		# Adicionando as arestas
		for key in arestas.iterkeys():
			g.add_edge(key);
			
		# Verificando timeout
		logDebug("Verificando timeout. limit: " + str(getTimeOut()) + ", atual: " + str(time() - self.time) );
		if (time() - self.time) >= getTimeOut():
			logDebug("Timeout!", __name__);
			return ['N', 0, [], time() - self.time, 'Steiner8'];
			
		# Declaracao da heuristica
		heuristic = euclidean()
		
		logDebug("grVertices: " + str(grVertices), __name__);
		
		# Obtem vertices com grau maior que 2
		ctv = []
		gr = grVertices;
		for vi in vertices:
			if findHashItem(gr, vi) and gr[vi] > 2:
				ctv.append(vi);
				
		logDebug("Vertices com grau maior que 2: " + str(ctv), __name__);
				
		
		ta = -1
		tb = -1

		for v in ctv:
			for tt in adjVertices[v]:
				if findItemList(terminais, tt) != -1:
					ta = v;
					tb = tt
					break
			if ta != -1 and tb != -1:
				break
				
			# Verificando timeout
			logDebug("Verificando timeout. limit: " + str(getTimeOut()) + ", atual: " + str(time() - self.time) );
			if (time() - self.time) >= getTimeOut():
				logDebug("Timeout!", __name__);
				break;
				
		logDebug("TA: " + str(ta) + ", TB: " + str(tb), __name__);
		
		# Nao encontrou vertice de partida
		if ta == tb and tb == -1:
			ta = terminais[0];
			
			if len(adjVertices[terminais[0]]) > 0:
				tb = adjVertices[terminais[0]][0];
			else:
				t1 = list(terminais)
				random.shuffle(t1)
				tb = t1[0];
				
			if ta == tb:
				return ['N', 0, [], time() - self.time, 'Steiner8'];

		g.del_edge((ta, tb));
		heuristic.optimize(g)
		result = heuristic_search(getGraph(), ta, tb, heuristic)
		
		logDebug("Caminho de TA ate TB sem aresta direta: " + str(result), __name__);
		
		# Nao existe caminho
		if len(result) == 0:
			return ['N', 0, [], time() - self.time, 'Steiner8'];

		
		comp = [result]
		tf = list(set(terminais) - set(result))
		logDebug("Terminais faltantes: " + str(tf), __name__);
		
		count = 0
		while len(tf) > 1:
		
			# Verificando timeout
			logDebug("Verificando timeout. limit: " + str(getTimeOut()) + ", atual: " + str(time() - self.time) );
			if (time() - self.time) >= getTimeOut():
				logDebug("Timeout!", __name__);
				break;
			
			logDebug("Terminais faltantes: " + str(tf), __name__);
			#comp.append(tf)
			
			result = heuristic_search(getGraph(), tf[0], tf[len(tf)-1], heuristic)
			logDebug("Caminho de " + str(tf[0]) + " ate " + str(tf[len(tf) - 1]) + ": " + str(result), __name__);
			
			if len(result) > 0:
				comp.append(result);
			
			tf = list(set(tf) - set(result))
			count += 1
			if count > (10*len(vertices)):
				logDebug("Limite de iteracoes atingido", __name__);
				break
		
		if len(tf) == 1:
			comp.append(tf);
		
		logDebug("Componentes: " + str(comp), __name__);

		# Caso exista o ciclo
		if len(comp) == 1 and existeCiclo(comp[0]) and containTerminais(comp[0]):
			return ['Y', computaCiclo(comp[0]), comp[0], time() - self.time, 'Steiner8'];
		
		else:

			logDebug("Tentando encaichar os componente no ciclo", __name__);
		
			ciclo = []
			count = 0
			while len(comp) > 1:
			
				# Verificando timeout
				logDebug("Verificando timeout. limit: " + str(getTimeOut()) + ", atual: " + str(time() - self.time) );
				if (time() - self.time) >= getTimeOut():
					logDebug("Timeout!", __name__);
					break;
				
				count += 1
				ca = comp.pop()
				cb = comp.pop()
				
				logDebug("Comp=" + str(comp), __name__);
				
				if  findItemList(adjVertices[ca[0]], cb[0]) != -1:
					ciclo.append(cb[0])
					for i in ca:
						ciclo.append(i)
						
					for i in cb[1:]:
						ciclo.append(i);
						
				elif findItemList(adjVertices[ca[len(ca)-1]], cb[0]) != -1:
					for i in ca:
						ciclo.append(i)
						
					for i in cb:
						ciclo.append(i);
						
				elif findItemList(adjVertices[ca[0]], cb[len(cb) - 1]) != -1:
					for i in cb:
						ciclo.append(i);
				
					for i in ca:
						ciclo.append(i)
						
				elif findItemList(adjVertices[ca[len(ca)-1]], cb[len(cb) - 1]) != -1:
					for i in ca:
						ciclo.append(i)
						
					cb.reverse();
					for i in cb:
						ciclo.append(i);
						
				else:
					logDebug("Nao existe encaixe", __name__);
					comp.append(cb);
					comp.append(ca);
					
					if count > 20*len(vertices):
						logDebug("Limite maximo de iteracoes atingidos...", __name__);
						break;
					
				
			logDebug("Ciclo: " + str(ciclo), __name__);
			if len(ciclo) > 0 and existeCiclo(ciclo):
				return ['Y', computaCiclo(ciclo), ciclo, time() - self.time, 'Steiner8'];
		
			return ['N', 0, [], time() - self.time, 'Steiner8'];