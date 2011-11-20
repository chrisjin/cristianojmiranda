import sys, itertools, math
from operator import itemgetter, attrgetter
from collectionUtils import *
from logger import *

nrVertices = 0;
nrArestas = 0;
nrTerminais = 0;
vertices = []
terminais = []
arestas = {}


# --
def loadGraph(fileName):

	logInfo("\n\nINICIO loadGraph");
	
	global nrVertices;
	global nrArestas;
	global nrTerminais;
	
	logDebug("Abrindo arquivo: " + fileName);
	file = open(fileName, "r")
	
	lineCount = 1;
	line = file.readline();
	while line:
		
		logDebug("Lendo linha: " + line.strip("\n"));
		strLine = line.split(' ');
		if lineCount == 1:	
			logDebug("Lendo file header");
			nrVertices = int(strLine[0]);
			nrArestas = int(strLine[1]);
			nrTerminais = int(strLine[2].strip());
			
		elif lineCount < nrArestas + 2:			
			vertice1 = int(strLine[0]); 
			vertice2 = int(strLine[1]);
			aresta = (vertice1, vertice2);
			logDebug("Lendo aresta: " + str(aresta));
			arestas[aresta] = float(strLine[2]);
			
			if findItemList(vertices, vertice1) == -1:
				vertices.append(vertice1);
			
			if findItemList(vertices, vertice2) == -1:
				vertices.append(vertice2);
		
		else:
			logDebug("Lendo terminal");
			if findItemList(terminais, int(strLine[0])) == -1:
				terminais.append(int(strLine[0]));
				
		line = file.readline();
		lineCount = lineCount + 1;
		
	
	file.close();
	logInfo("\nFIM loadGraph");


#--
def findMenorAresta(vorigem, vertices, exclude, checkBothSide):

	logDebug("FindMenorAresta, vorigem=" + str(vorigem) + ", vertices=" + str(vertices) + ", exclude=" + str(exclude) + ", checkBothSide=" + str(checkBothSide));
	logDebug("arestas: " + str(arestas));
	aresta = [];

	for j in vertices:
		if j != vorigem:
			arestaA = (vorigem, j);
			arestaB = (j, vorigem);
			
			logDebug("arestaA: " + str(arestaA));
			logDebug("arestaB: " + str(arestaB));

			if findHashItem(arestas, arestaA) and (findItemList(exclude, arestaA[0]) == -1 or findItemList(exclude, arestaA[1]) == -1):
				logDebug("Existe arestaA");
				aresta.append([arestaA[0], arestaA[1], arestas[arestaA]]);
			
			if checkBothSide and findHashItem(arestas, arestaB) and (findItemList(exclude, arestaB[0]) == -1 or findItemList(exclude, arestaB[1]) == -1):
				logDebug("Existe arestaB");
				aresta.append([arestaB[0], arestaB[1], arestas[arestaB]]);
		
	logDebug("==>Aresta adjacentes: " + str(aresta));
	if len(aresta) > 0:
		aresta = sorted(aresta, key=itemgetter(2));
		logDebug("Menor aresta: " + str(aresta[0]))
		return (aresta[0][0], aresta[0][1]);
	else:
		logDebug("Nao existe menor aresta");
		return None;
	

#-- Computa o tamanho de um cliclo
def computaCiclo(ciclo):
	logInfo("\n\nINICIO computaCiclo");
	logDebug("ciclo=" + str(ciclo));
	
	size = 0.0;
	for i in range(len(ciclo)):
		arestaA = [];
		arestaB = [];
		if i < len(ciclo)-1:
			arestaA = (ciclo[i], ciclo[i+1]);
			arestaB = (ciclo[i+1], ciclo[i]);
		else:
			arestaA = (ciclo[0], ciclo[i]);
			arestaB = (ciclo[i], ciclo[0]);
			
		if findHashItem(arestas, arestaA):
			vr = arestas[arestaA];
			logDebug("arestaA: " + str(arestaA) + ", value: " + str(vr));
			size = size + vr;
		elif findHashItem(arestas, arestaB):
			vr = arestas[arestaB];
			logDebug("arestaB: " + str(arestaB) +  ", value: " + str(vr));
			size = size + vr;
		
	
	logInfo("FIM computaCiclo. value=" + str(size));
	return size;
	
	
def containTerminais(ciclo):
	count = 0;
	for v in terminais:
		if findItemList(ciclo, v):
			count = count + 1;
	
	if len(terminais) == count:
		return True;
	
	return False;
	
#--
def validaGrafo():
	if nrArestas == 0 or nrTerminais == 0 or (nrVertices == 1 and nrTerminais == 1):
		return False;
	return True;
	
def getNrVertices():
	return nrVertices;
	
def getNrArestas():
	return nrArestas;
	
def getNrTerminais():
	return nrTerminais;