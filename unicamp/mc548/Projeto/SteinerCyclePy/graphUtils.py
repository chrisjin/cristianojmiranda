import sys, itertools, math
from time import time;
from operator import itemgetter, attrgetter
from pygraph.classes.graph import graph
from pygraph.classes.digraph import digraph
from pygraph.algorithms.searching import *
from pygraph.readwrite.dot import write
from pygraph.algorithms.cycles import *
from collectionUtils import *
from graphUtils import *
from logger import *


# ----------- Variaveis globais -----------------

# Grafo
gr = graph()

# Nr de vertices
nrVertices = 0;

# Nr de arestas
nrArestas = 0;

# Nr de Terminais
nrTerminais = 0;

# Vertices do grafo
vertices = []

# Terminais do grafo
terminais = []

# Hash com o custo das arestas
arestas = {}

# Grau de cada vertice
grVertices = {};

# Vertices adjacentes
adjVertices = {}

# Timeout de processamento em segundos
timeOut = 3600

# --
def loadGraph(fileName, timeInicio):

	loadTime = time();
	logInfo("\n\nINICIO loadGraph");
	
	global gr;
	global nrVertices;
	global nrArestas;
	global nrTerminais;
	
	# Abre o arquivo do grafo para leitura
	logDebug("Abrindo arquivo: " + fileName);
	file = open(fileName, "r")
	
	# Extrai todas as informacoes do grafo
	lineCount = 1;
	line = file.readline();
	while line:
	
		# Verificando timeout
		logDebug("Verificando timeout. limit: " + str(getTimeOut()) + ", atual: " + str(time() - timeInicio), __name__);
		if (time() - timeInicio) >= getTimeOut():
			logDebug("Timeout!", __name__);
			print "Timeout na leitura do arquivo"
			exit(1);
		
		logDebug("Lendo linha: " + line.strip("\n"));
		strLine = line.split(' ');
		# Obtendo o head do arquivo
		if lineCount == 1:	
			logDebug("Lendo file header");
			nrVertices = int(strLine[0]);
			nrArestas = int(strLine[1]);
			nrTerminais = int(strLine[2].strip());
			
		# Obtendo as arestas do grafo
		elif lineCount < nrArestas + 2:			
			vertice1 = int(strLine[0]); 
			vertice2 = int(strLine[1]);
			aresta = (vertice1, vertice2);
			logDebug("Lendo aresta: " + str(aresta));
			arestas[aresta] = float(strLine[2]);
			
			# Seta o vertice na lista de vertices
			if findItemList(vertices, vertice1) == -1:
				vertices.append(vertice1);
			
			if findItemList(vertices, vertice2) == -1:
				vertices.append(vertice2);
				
			# atualiza o grau dos vertices
			if findHashItem(grVertices, vertice1):
				grVertices[vertice1] = grVertices[vertice1] + 1;
			else:
				grVertices[vertice1] = 1;
				
			if findHashItem(grVertices, vertice2):
				grVertices[vertice2] = grVertices[vertice2] + 1;
			else:
				grVertices[vertice2] = 1;
				
			# Seta vertices adjacentes
			if findHashItem(adjVertices, vertice1):
				adjVertices[vertice1].append(vertice2);
			else:
				adjVertices[vertice1] = [vertice2];
				
			if findHashItem(adjVertices, vertice2):
				adjVertices[vertice2].append(vertice1);
			else:
				adjVertices[vertice2] = [vertice1];
		
		# Obtendo os terminais
		else:
			logDebug("Lendo terminal");
			if findItemList(terminais, int(strLine[0])) == -1:
				terminais.append(int(strLine[0]));
				
		line = file.readline();
		lineCount = lineCount + 1;
		
	
	file.close();
	
	# Seta os vertices fantasmas
	if len(vertices) < nrVertices:
		for i in range(nrVertices):
			if findItemList(vertices, i) == -1:
				vertices.append(i);
		
	# Criando o grafo
	gr = graph()
	
	# Adicionando os vertices
	gr.add_nodes(vertices)
	
	# Adicionando as arestas
	for key in arestas.iterkeys():
		gr.add_edge(key, wt=arestas[key]);
		
	
	logDebug("Terminais=" + str(terminais));
	logDebug("grVertices=" + str(grVertices));
	logDebug("adjVertices=" + str(adjVertices ));
		
	logDebug("Graph: " + str(gr));
	logInfo("\nFIM loadGraph. Tempo de execucao=" + str(time() - loadTime));


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
	
	
# -- Verifica se o ciclo contem todos os terminais --
def containTerminais(ciclo):

	if ciclo == None:
		return False;
	
	logDebug('Verificando se ciclo contem todos os terminais: ' + str(ciclo) + ", terminais=" + str(terminais));
	if len(ciclo) < len(terminais):
		logDebug('1-Ciclo incompleto.')
		return False;

	count = 0;
	for v in terminais:
		if findItemList(ciclo, v) >= 0:
			count = count + 1;
	
	if len(terminais) == count:
		logDebug('Ciclo valido.')
		return True;
	
	logDebug('2-Ciclo incompleto.')
	return False;
	
	
def existeCiclo(ciclo):
	
	logDebug("Verificando ciclo: " + str(ciclo), __name__);
	
	# Verifica vertices duplicados
	dp = {};
	for v in ciclo:
		if findHashItem(dp, v):
			return False;
		else:
			dp[v] = 1;
			
			
	for i in range(len(ciclo)):
		va = -1
		vb = -1
		if i < len(ciclo) - 1:
			va = ciclo[i]
			vb = ciclo[i+1]
		else:
			va = ciclo[i]
			vb = ciclo[0]
			
		if findHashItem(adjVertices, va) == False or findItemList(adjVertices[va], vb) == -1:
			return False;
	
	
	return True;
		
			
			
		
	
#-- Verifica se o grafo e valido para a busca
def validaGrafo():
	logInfo("INICIO validaGrafo");
	if nrArestas == 0 or nrTerminais == 0:
		logInfo("Grafo invalido!");
		return False;
		
	# Verifica se existe algum terminal com grau 0
	for t in terminais:
		if findHashItem(grVertices, t):
			if grVertices[t] <= 0:
				logInfo("Grafo invalido!");
				return False
		else:
			logInfo("Grafo invalido!");
			return False
	
	logInfo("Grafo valido!");
	return True;
	
def getNrVertices():
	return nrVertices;
	
def getNrArestas():
	return nrArestas;
	
def getNrTerminais():
	return nrTerminais;
	
def getGraph():
	return gr;
	
def getTimeOut():
	return timeOut;
	
def setTimeOut(limit):
	global timeOut;
	timeOut = limit;