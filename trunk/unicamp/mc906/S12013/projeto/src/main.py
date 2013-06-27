import logging
from cluster import *
from dicionario import *
import time


# Executa o processo de custerizacao para um configuracao de K-Means
def clusterizar(np, c, srndc, kmeansInit, clusterResult, mnbtch, dicionario, cluster):
	
	print '\n-> Criando um dicionario com ' + str(np) + ' palavras...'
	dic = dicionario.obterDicionario(np);
		
	print '\n-> Clusterizando dicionario com ' + str(np) + ' palavras em ' \
			+ str(c) + ' grupos, randomize centroids seeds ' + str(srndc) \
			+ ', kmeansInit ' + str(kmeansInit) + ', minibatch ' + str(mnbtch);
					
	# Obtem os centroides
	centroides = kmeansInit;
	if kmeansInit == 'ndarray':
		centroides = cluster.obterCentroidesIniciais(dicionario, np);
	
	# Armazena o resultado
	result = cluster.executarKMeans(dic, nrClusters=c, init=centroides, verbose=1, random_state=srndc, miniBatch=mnbtch);
	clusterResult[(np, srndc, c, str(kmeansInit), mnbtch)] = result;

# Realiza processo de clusterizacao K-Means
def clusterizacaoKmeans(dicionario, cluster):

	# Armazena o resultado das clusterizacoes
	clusterResult = {};
	
	# Tempor para iniciar processo de clusterizacao
	t0cluster = time.time();
	
	# Nr de palavras por dicionario
	for np in [500]:#[100, 200, 500]:
	
		# Seeds para randomizar centroides
		for srndc in [None, 1000, 1500, 2000]:
		
			# Nr de clusters
			for c in [20]:
	
				# Altera a maneira de escolher os centroides
				for kmeansInit in ['ndarray']:#['k-means++', 'random', 'ndarray']:

					# Alterna entre minibatch e kmeans puro
					# A clusterizacao via minibatch kmeans demonstrou boms resultados
					for mnbtch in [True]:#[True, False]:
						clusterizar(np, c, srndc, kmeansInit, clusterResult, mnbtch, dicionario, cluster);
	
	print 'Tempo total para clusterizacao: ' + str(time.time() - t0cluster) + 's';
	
	# TODO: Analisar os resultados para ver qual a melhor configuracao
	# ver: http://www.isa.utl.pt/dm/biocomp/biocomp/aulasclustering.pdf
	print 'Resultado Clusterizacao (configuracao) - (ho, co, vm, ar, sc): '
	
	clusterResultVt = clusterResult.values();
	clusterResultVt.sort();
	melhorConfiguracao = None;
	
	print 'Configuracoes ordenadas: ', clusterResultVt
	
	for c in clusterResult:
		r =  clusterResult[c];
		print c, '-', r
		
		if r == clusterResultVt[-1]:
			melhorConfiguracao = c;
	
	print '\n\n\n\n\n'
	print '---------------------------------------------------'
	print 'Melhor configuracao: ' + str(melhorConfiguracao);
	print '---------------------------------------------------'
	
	# realiza a melhor clusterizacao novamente
	clusterizar(melhorConfiguracao[0], melhorConfiguracao[2], melhorConfiguracao[1], melhorConfiguracao[3], {}, melhorConfiguracao[4], dicionario, cluster)
	
# Executa clusterizacao com DBScan
def clusterizacaoDBSCAN(dicionario, cluster):
	
	print '\n-> SpectralClustering';

	# Armazena o resultado das clusterizacoes
	clusterResult = {};

	# Nr de palavras por dicionario
	for np in [100, 200, 500]:

		print '\n-> Criando um dicionario com ' + str(np) + ' palavras...'
		dic = dicionario.obterDicionario(np);
	
		# Seeds para randomizar centroides
		for srndc in [None, 100, 50, 1000]:	

			# Testa com varios eps
			for eps in [1, .95, .9, .85, .8, .7, .6, .5, .4, .3, .2, .1, .01]:

				print '\n-> Clusterizando dicionario com ' + str(np) + ', randomize centroids seeds ' + str(srndc) + ', eps ' + str(eps);
				r = cluster.executarDBSCAN(dicionarioArquivo=dic, verbose=1, random_state=srndc, eps=eps);

				# Adiciona o resultado
				clusterResult[(np, srndc, eps)] = r;

	clusterResultVt = clusterResult.values();
	clusterResultVt.sort();
	melhorConfiguracao = None;
	
	print 'Configuracoes ordenadas: ', clusterResultVt
	
	for c in clusterResult:
		r =  clusterResult[c];
		print c, '-', r
		
		if r == clusterResultVt[-1]:
			melhorConfiguracao = c;
	
	print '\n\n\n\n\n'
	print '---------------------------------------------------'
	print 'Melhor configuracao: ' + str(melhorConfiguracao);
	print '---------------------------------------------------'
	cluster.executarDBSCAN(dicionarioArquivo=dicionario.obterDicionario(melhorConfiguracao[0]), verbose=1, random_state=melhorConfiguracao[1], eps=melhorConfiguracao[2]);
	
	
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
	print '|   Fernando Massunari   RA 081398            |'
	print '+---------------------------------------------+'
	print '\n\n\n\n\n'
	
	print '-> Criando dicionario...';
	dicionario = Dicionario(ignoreBackup=False);
	
	print '\n-> Dicionario por tipo de mensagem'
	dicionario.exibirDistribuicao(dicionario.dicionarioPorMensagem);
	
	print '\n-> Criando Cluster...';
	cluster = Cluster();
	
	# Realiza clusterizacao via K-Means
	clusterizacaoKmeans(dicionario, cluster);
	
	# Realiza clusterizacao via dbscan
	#clusterizacaoDBSCAN(dicionario, cluster);
	
	# Reliza a classificacao
	#classificacao();
	
	

if __name__ == '__main__':
	executar();
