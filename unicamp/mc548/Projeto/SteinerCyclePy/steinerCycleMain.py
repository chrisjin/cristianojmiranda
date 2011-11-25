import sys, itertools, math, random
from operator import itemgetter, attrgetter
from threading import Thread
from time import time
from graphUtils import *
from steinerCycle1 import *
from steinerCycle2 import *
from steinerCycle3 import *
from steinerCycle4 import *
from steinerCycle5 import *
from steinerCycle6 import *
from steinerCycle7 import *
from logger import *

# Define qual o melhor algoritimo executado
def verificaMelhorAlgoritmo(results):
	
	logDebug("Resultados: ", __name__);
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

	# Obtem o tempe de inicio
	timeInicio = time()
	
	if len(args) < 3:
		logInfo("Esta faltando parametros para executar");
		print "Missing Params. Example: steinerCycleMain <file_graph.scp> <timeout>";
		
	else:
	
		# Seta timeout de processamento
		setTimeOut(int(args[2]));
	
		# Carrega o grafo do arquivo
		loadGraph(args[1], timeInicio)
		
		# Verifica se o grafo apresenta ciclos
		if validaGrafo():
			
			# Monta a lista com as threads
			thds = [Steiner1(), Steiner2(), Steiner3(), Steiner4(), Steiner5(), Steiner6(), Steiner7()];
			
			# Executa as threads
			for st in thds:
				st.time = timeInicio
				st.start();
				
			# Espera as threads terminarem
			wait = True;
			while wait:
			
				# Valida timeOut
				if (time() - timeInicio) >= getTimeOut():
					#print "Timeout"
					break;
			
				wait = False;
				for st in thds:
					if len(st.result) == 0:
						wait = True;
						break;
				
			results = [];
			# Obtem os results
			for st in thds:
				results.append(st.result);
				
			logDebug("=======================Processamento finalizado===================", __name__)
			
			# Computa o melhor algoritimo que resolveu o problema
			melhorAlg = verificaMelhorAlgoritmo(results);
			
			if len(melhorAlg) > 0:
				logDebug("Verificando custo novamente:" + str(computaCiclo(melhorAlg[2])), __name__);
				
				cl = ""
				for n in melhorAlg[2]:
					cl = cl + str(n) + " "
					
				print "Best cycle"
				print cl
				print "endcycle\n"
				print "Solution & Time & Best Solution Value"
				print melhorAlg[0] + " & " + str(melhorAlg[3]) + " & " + str(melhorAlg[1])
				return;
			
		# Nao foi encontrado a solucao para o problema
		print "Best cycle\nNoCycle\nendcycle\n\nSolution & Time & Best Solution Value\nN & " + str(time() - timeInicio);


# Flag de log
enabledLog = False;

if len(sys.argv) > 3 and ('true' == sys.argv[3] or 's' == sys.argv[3]) :
	enabledLog = True;
	
		
# Abre o arquivo de log
openLogger(enabledLog, None);

# Executa a verificacao do ciclo
run(sys.argv);

# Fecha o arquivo de log
closeLogger();

# Finaliza o programa
exit(0);