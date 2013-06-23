import logging
from cluster import *
from dicionario import *

def executar():

	# Configura o log
	logging.basicConfig(filename='../log/mc906.log',level=logging.DEBUG,format='%(asctime)s %(levelname)s %(message)s');

	print '\n\n\n\n\n'
	print '+---------------------------------------------+'
	print '| MC906 - Introducao a inteligencia artificial|'
	print '| Projeto                                     |'
	print '|---------------------------------------------|'
	print '| Alunos:                                     |' 
	print '|   Cristiano J. Miranda RA 083382            |'
	print '|   Fernando Massunari   RA                   |'
	print '+---------------------------------------------+'
	print '\n\n\n\n\n'
	
	print '-> Criando dicionario...';
	dicionario = Dicionario(ignoreBackup=False);
	
	print '\n-> Dicionario por tipo de mensagem'
	dicionario.exibirDistribuicao(dicionario.dicionarioPorMensagem);
	
	print '\n-> Criando Cluster...';
	cluster = Cluster();
	
	# Armazena o resultado das clusterizacoes
	clusterResult = {};
	
	# Nr de palavras
	for np in [100, 200, 500]:
	
		# Extraction features a serem testados
		for f in [0]:
		
			# Nr de clusters
			for c in [20]:
	
				# Altera a maneira de escolher os centroides
				for kmeansInit in ['k-means++']:
	
					print '\n-> Criando um dicionario com ' + str(np) + ' palavras...'
					dic = dicionario.obterDicionario(np, randomFlg=False);
		
					print '\n-> Clusterizando dicionario com ' + str(np) + ' palavras em ' \
							+ str(c) + ' grupos, feature ' + str(f) + ', kmeansInit ' + str(kmeansInit);
					
					# Armazena o resultado
					result = cluster.executarKMeans(dic, nrClusters=c, featureExtraction=f, init=kmeansInit, verbose=1);
					clusterResult[(np, f, c, kmeansInit)] = result;
				
	# TODO: Analisar os resultados para ver qual a melhor configuracao
	# ver: http://www.isa.utl.pt/dm/biocomp/biocomp/aulasclustering.pdf
	print 'Resultado Clusterizacao (configuracao) - (ho, co, vm, ar, sc): '
	
	clusterResultVt = clusterResult.values();
	clusterResultVt.sort();
	melhorConfiguracao = None;
	
	for c in clusterResult:
		r =  clusterResult[c];
		print c, '-', r
		
		if r == clusterResultVt[-1]:
			melhorConfiguracao = c;
	
	print 'Melhor configuracao: ' + str(melhorConfiguracao);
	

if __name__ == '__main__':
	executar();