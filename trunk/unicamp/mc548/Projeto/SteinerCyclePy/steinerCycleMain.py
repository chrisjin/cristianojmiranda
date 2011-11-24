import sys, itertools, math, random
from operator import itemgetter, attrgetter
from time import time
from graphUtils import *
from steinerCycle1 import *
from steinerCycle2 import *
from steinerCycle3 import *
from steinerCycle4 import *
from steinerCycle5 import *
from steinerCycle6 import *
from logger import *


from pygraph.algorithms.accessibility import *
from pygraph.algorithms.critical import *
from pygraph.algorithms.heuristics.chow import *
from pygraph.algorithms.heuristics.euclidean import *
from pygraph.algorithms.minmax import *

# Define qual o melhor algoritimo executado
def verificaMelhorAlgoritmo(results):
	
	logDebug("Resultados: ");
	tmp = []
	for rt in results:
		logDebug(str(rt));
		if len(rt) > 0 and 'Y' == rt[0]:
			tmp.append(rt);
		
	if len(tmp) > 0:
		results = sorted(tmp, key=itemgetter(1,3));
		logDebug("Melhor ciclo: " + str(results[0]));
		return results[0]
		
	logInfo("Nao existe ciclo");
	return [];

# Run function
def run(args):

	t = time()
	if len(args) < 3:
		logInfo("Esta faltando parametros para executar");
		print "Missing Params. Example: steinerCycleMain <file_graph.scp> <timeout>";
		
	else:
	
		# Seta timeout de processamento
		setTimeOut(int(args[2]));
	
		# Carrega o grafo do arquivo
		loadGraph(args[1])
		
		# todo: remove!
		return;
		
		# Verifica se o grafo apresenta ciclos
		if validaGrafo():
			# Executa a primeira abordagem
			st1 = Steiner1()
			st1.start();
			
			# Executa a segunda abordagem
			st2 = Steiner2()
			st2.start();
			
			# Executa a terceira abordagem
			st3 = Steiner3();
			st3.start();
			
			# Executa a quarta abordagem
			st4 = Steiner4();
			st4.start();
			
			# Executa a quarta abordagem
			st5 = Steiner5();
			st5.start();
			
			# Executa a quarta abordagem
			st6 = Steiner6();
			st6.start();
			
			# Lock para finalizar as threads
			logDebug("Esperando processamento.");
			while(len(st1.result) == 0 or 
				  len(st2.result) == 0 or 
				  len(st3.result) == 0 or 
				  len(st4.result) == 0 or
				  len(st5.result) == 0 or
				  len(st6.result) == 0):
					if (time() - t) >= getTimeOut():
						logDebug("Timeout!");
					continue;
			
			logDebug("=======================Processamento finalizado===================");
			results = [];
			results.append(st1.result);
			results.append(st2.result);
			results.append(st3.result);
			results.append(st4.result);
			results.append(st5.result);
			results.append(st6.result);
			
			melhorAlg = verificaMelhorAlgoritmo(results);
			if len(melhorAlg) > 0:
				logDebug("Verificando custo novamente:" + str(computaCiclo(melhorAlg[2])));
				
				cl = ""
				for n in melhorAlg[2]:
					cl = cl + str(n) + " "
					
				print "Best cycle"
				print cl
				print "endcycle\n"
				print "Solution & Time & Best Solution Value"
				print melhorAlg[0] + " & " + str(melhorAlg[3]) + " & " + str(melhorAlg[1])
				return;
			
		print "Best cycle\nNoCycle\nendcycle\n\nSolution & Time & Best Solution Value\nN & " + str(time() - t);


# Abre o arquivo de log
openLogger(True, None);

# Executa a verificacao do ciclo
run(sys.argv);

print "Graph"
print getGraph();

print "cut_edges"
print cut_edges(getGraph());

print "cut_nodes"
print cut_nodes(getGraph());

print "mutual_accessibility"
print mutual_accessibility(getGraph())

print "connected_components"
print connected_components(getGraph())

print "critical_path"
print critical_path(getGraph())

print "transitive_edges"
print transitive_edges(getGraph());

print "chow"
c = chow( "Wales", "North Korea", "Russia" );
print c.optimize(getGraph());

#print heuristic_search(getGraph(), 1, 3, c);

print "depth_first_search"
st, pre, post = depth_first_search(getGraph(), root=terminais[0])
print "Spainning tree" 
print st

dg = digraph();
dg.add_spanning_tree(st);
print "Digraph"
print dg

print "Critical path"
print critical_path(dg)


print "shortest_path"
print shortest_path(getGraph(), 0)

print "\n\nChow part ii..."
heuristic = chow(0, 2)
print "Optimize dg"
heuristic.optimize(getGraph())

print "Result..."
result = heuristic_search( getGraph(), 0, 6, heuristic )
print result;


ta = -1
tb = -1

for t in terminais:
	for tt in adjVertices[t]:
		if findItemList(terminais, tt) != -1:
			ta = t;
			tb = tt
			break
	if ta != -1 and tb != -1:
		break
		
print "ta: ", ta, ", tb: ", tb, "\n-------------------	\n\n"

print "Euclidian"
he = euclidean()

ct = 0;
for t in vertices:
	getGraph().add_node_attribute(t, ('position',(0,ct)))
	ct += 1;

getGraph().del_edge((ta, tb));
he.optimize(getGraph())
result = heuristic_search(getGraph(), ta, tb, he)

print "RESULTADO!"
print result

comp = [result]
tf = list(set(terminais) - set(result))
count = 0
while len(tf) > 1:
	print "Terminais faltantes: ", tf
	comp.append(tf)
	result = heuristic_search(getGraph(), tf[0], tf[len(tf)-1], he)
	print "rt: ", result
	tf = list(set(tf) - set(result))
	count += 1
	if count > 20:
		break
	
if len(tf) == 1:
	comp.append(tf);
	
print "Comp: ", comp

if len(comp) == 0:
	print "Ciclo heuristico: ", comp[0]
	
else:

	print "adj: ", adjVertices

	ciclo = []
	count = 0
	while len(comp) > 1:
		count += 1
		ca = comp[0]
		cb = comp[1]
		
		comp.remove(ca)
		comp.remove(cb)
		
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
			
		
	print ciclo

	
print "============================================================="


#----
ciclo = []
while not containTerminais(ciclo):
	
	tt = list(terminais)
	random.shuffle(tt)
	random.shuffle(tt)
	print tt
	
	for i in range(len(tt)):
		if len(ciclo) == 0:
			ciclo.append(tt[i]);
			
		sp = shortest_path(getGraph(), tt[i])
		print "sp"
		print sp
			
		
	
	break;
	
print "\n\n====================ciclo: "
print ciclo

#----

# Fecha o arquivo de log
closeLogger();