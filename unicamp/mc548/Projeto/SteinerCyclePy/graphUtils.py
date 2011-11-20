import sys, itertools, math
from operator import itemgetter, attrgetter
from collectionUtils import *

nrVertices = 0;
nrArestas = 0;
nrTerminais = 0;
vertices = []
terminais = []
arestas = {}


# --
def loadGraph(fileName):

	global nrVertices;
	global nrArestas;
	global nrTerminais;
	
	file = open(fileName, "r")
	
	lineCount = 1;
	line = file.readline();
	while line:
	
		str = line.split(' ');
		if lineCount == 1:	
			nrVertices = int(str[0]);
			nrArestas = int(str[1]);
			nrTerminais = int(str[2].strip());
			
		elif lineCount < nrArestas + 1:
			vertice1 = int(str[0]); 
			vertice2 = int(str[1]);
			aresta = (vertice1, vertice2);
			arestas[aresta] = float(str[2]);
			
			if findItemList(vertices, vertice1) == -1:
				vertices.append(vertice1);
			
			if findItemList(vertices, vertice2) == -1:
				vertices.append(vertice2);
		
		elif lineCount < nrArestas + nrVertices + 1:
			if findItemList(terminais, int(str[0])) == -1:
				terminais.append(int(str[0]));
				
		line = file.readline();
		lineCount = lineCount + 1;
		
	
	file.close();


#--
def findMenorAresta(i, vertices, checkBothSide):
	aresta = [];

	for j in terminais:
		if j != i:
			arestaA = (i, j);
			arestaB = (j, i);

			if findHashItem(arestas, arestaA) == 1:
				aresta.append([arestaA[0], arestaA[1], arestas[arestaA]]);
			
			if checkBothSide and findHashItem(arestas, arestaB) == 1:
				aresta.append([arestaB[0], arestaB[1], arestas[arestaB]]);
		
	if len(aresta):
		aresta = sorted(aresta, key=itemgetter(2));
		return (aresta[0][0], aresta[0][1]);
	else:
		return (-1, -1);
	

#-- Computa o tamanho de um cliclo
def computaCiclo(ciclo):
	size = 0.0;
	for i in range(len(ciclo)):
		arestaA = [];
		arestaB = [];
		if i <= (len(ciclo) - 2):
			arestaA = (ciclo[i], ciclo[i+1]);
			arestaB = (ciclo[i+1], ciclo[i]);
		else:
			arestaA = (ciclo[0], ciclo[i-1]);
			arestaB = (ciclo[i-1], ciclo[0]);
			
		if findHashItem(arestas, arestaA) == 1:
			size = size + arestas[arestaA];
		elif findHashItem(arestas, arestaB) == 1:
			size = size + arestas[arestaB];
		
			
	return size;
	
#--
def validaGrafo():
	if nrArestas == 0 or nrTerminais == 0 or (nrVertices == 1 and nrTerminais == 1):
		return 0;
	return 1;	
	
	
def getNrVertices():
	return nrVertices;
	
def getNrArestas():
	return nrArestas;
	
def getNrTerminais():
	return nrTerminais;