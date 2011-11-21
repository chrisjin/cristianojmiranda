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

class Steiner6(Thread):
	result = [];
	def run(self):
		logDebug("Thread Steiner6 running...");
		self.result = steinerCycle6();
		logDebug("Thread Steiner6 finished");
		

# Adiciona os terminais faltantes		
def normalizaTerminais(ciclo, tempo):
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
	
	
	# Obtem os vertices nao terminais
	nTerminais = [];
	for nt in ciclo:
		if findItemList(terminais, nt) == -1:
			nTerminais.append(nt);
			
	return nTerminais;

		
# --
def steinerCycle6():
	t = time();
	
	# Criando um novo grafo
	g = graph()
	
	# Adicionando os vertices
	g.add_nodes(vertices)
	
	# Adicionando as arestas
	for key in arestas.iterkeys():
		g.add_edge(key);
		
	# Tenta localizar um ciclo
	ciclo = find_cycle(g);
	
	if len(ciclo) > 0:
		
		rt = [];
		cicloCopy = list(ciclo);
		while len(ciclo) > 0:
			logDebug("CicloSt6: " + str(ciclo));
			
			# Verificando timeout
			logDebug("Verificando timeout. limit: " + str(getTimeOut()) + ", atual: " + str(time() - t) );
			if (time() - t) >= getTimeOut():
				logDebug("Timeout!");
				break;
				
			# Adiciona os vertices terminais ao ciclo
			nTerminais = normalizaTerminais(ciclo, t)
			
			# Verifica se contem o ciclo
			if containTerminais(ciclo):
				rt.append([computaCiclo(ciclo), ciclo]);
				
				if len(nTerminais) > 0:
					g.del_node(nTerminais[0])
					ciclo = find_cycle(g);
					
					if cicloCopy == ciclo:
						break;
					else:
						cicloCopy = list(ciclo);
				
			else:
				break;
		
		logDebug("RtSt6: " + str(rt));
		if len(rt) > 0:
			rt = sorted(rt, key=itemgetter(0))
			return ['Y', rt[0][0], rt[0][1], time() - t, 'Steiner6'];
	
	return ['N', 0, [], time() - t, 'Steiner6'];