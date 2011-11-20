import sys, itertools, math
from operator import itemgetter, attrgetter

from pygraph.classes.graph import graph
from pygraph.algorithms.searching import depth_first_search

from collectionUtils import *
from graphUtils import *
	
#--
def cicloTerminais():
	ciclo = [];
	for i in terminais:
		aresta = findMenorAresta(i, terminais, True);
		if aresta != (-1, -1):
			if findItemList(ciclo, aresta[0]) == -1:
				ciclo.append(aresta[0]);
			if findItemList(ciclo, aresta[1]) == -1:
				ciclo.append(aresta[1]);
					
	# Verifica se existe mesmo o ciclo
	aresta = findMenorAresta(ciclo[0], [ciclo[len(ciclo)-1]], False);
	if aresta != (-1, -1):
	
		if len(ciclo) <= 2:
			print "TODO: deve checar o autociclo! - Nao existe ciclo";
			
		else:
			print "Ciclo: "
			print ciclo;
			sizeCiclo = computaCiclo(ciclo);
			print "Tamanho: "
			print sizeCiclo;
	else:
		print "Nao existe ciclo";
	
print "====py steiner cycle====\n"
loadGraph("teste.scp")

print "Vertices: " 
print vertices;
print "\nArestas: "
print arestas;
print "\nTerminais: ";
print terminais;
print "nrArestas="
print getNrArestas();
print "nrTerminais="
print getNrTerminais();

if validaGrafo() == 1:
	cicloTerminais();
else:
	print "Grafo invalido";