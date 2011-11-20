import sys, itertools, math
from operator import itemgetter, attrgetter
from time import time
from graphUtils import *
from steinerCycle1 import *
from steinerCycle2 import *
from logger import *

# Define qual o melhor algoritimo executado
def verificaMelhorAlgoritmo(results):
	
	logDebug("Resultados: " + str(results));
	
	tmp = []
	for rt in results:
		if len(rt) > 0 and 'Y' == rt[0]:
			tmp.append(rt);
		
	if len(tmp) > 0:
		results = sorted(tmp, key=itemgetter(1));
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
		# Carrega o grafo do arquivo
		loadGraph(args[1])
		
		# Verifica se o grafo apresenta ciclos
		if validaGrafo():
			# Executa a primeira abordagem
			st1 = Steiner1()
			st1.start();
			
			# Executa a segunda abordagem
			st2 = Steiner2()
			st2.start();
			
			# Lock para finalizar as threads
			logDebug("Esperando processamento.");
			while(len(st1.result) == 0 or len(st2.result) == 0):
				continue;
			
			logDebug("=======================Processamento finalizado===================");
			results = [];
			results.append(st1.result);
			results.append(st2.result);
			
			melhorAlg = verificaMelhorAlgoritmo(results);
			if len(melhorAlg) > 0:
				
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

# Fecha o arquivo de log
closeLogger();