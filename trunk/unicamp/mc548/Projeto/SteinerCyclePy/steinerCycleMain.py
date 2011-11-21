import sys, itertools, math
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

# Fecha o arquivo de log
closeLogger();