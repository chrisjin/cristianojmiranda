import sys
import time
import logging

from cluster import *
from dicionario import *
from classificacao import * 

# Executa o processo de custerizacao para um configuracao de K-Means
def clusterizarKm(np, c, srndc, kmeansInit, clusterResult, mnbtch, dicionario, cluster):
	
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
	print '>>>', (np, srndc, c, str(kmeansInit), mnbtch);
	result = cluster.executarKMeans(dic, nrClusters=c, init=centroides, verbose=1, random_state=srndc, miniBatch=mnbtch);
	clusterResult[(np, srndc, c, str(kmeansInit), mnbtch)] = result;

# Realiza processo de clusterizacao K-Means
def clusterizacaoKmeans(dicionario, cluster):

	# Armazena o resultado das clusterizacoes
	clusterResult = {};
	
	# Tempor para iniciar processo de clusterizacao
	t0cluster = time.time();
	
	# Nr de palavras por dicionario
	for np in [100, 200, 500, 725, 1000]:
	
		# Seeds para randomizar centroides
		for srndc in [None, 1000, 1500, 2000, 4000, 10000, 5000000, 10000000]:
		
			# Nr de clusters
			for c in [20]:
	
				# Altera a maneira de escolher os centroides
				for kmeansInit in ['k-means++', 'random', 'ndarray']:

					# Alterna entre minibatch e kmeans puro
					# A clusterizacao via minibatch kmeans demonstrou boms resultados !
					for mnbtch in [True, False]:
						clusterizarKm(np, c, srndc, kmeansInit, clusterResult, mnbtch, dicionario, cluster);
	
	print 'Tempo total para clusterizacao: ' + str(time.time() - t0cluster) + 's';
	
	print 'Resultado Clusterizacao (configuracao) - (c, na, ho, co, vm, ar): '
	
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
	print 'Melhor configuracao: ' + str(melhorConfiguracao) + ', ' + str(clusterResultVt[-1]);
	print '---------------------------------------------------'
	print '\n\n\n\n\n'
	
# Executa clusterizacao com DBScan
def clusterizacaoDBSCAN(dicionario, cluster):
	
	print '\n-> SpectralClustering';

	# Armazena o resultado das clusterizacoes
	clusterResult = {};

	# Nr de palavras por dicionario
	for np in [100]:#[100, 200, 500]:

		print '\n-> Criando um dicionario com ' + str(np) + ' palavras...'
		dic = dicionario.obterDicionario(np);
	
		# Seeds para randomizar centroides
		for srndc in [None]: #[None, 100, 500]:

			# Testa com varios eps
			for eps in [.95]:#[.95]:#[.95, .75, .5, .1, .01]:

				for sp in [10]:#[.85, 1.04, 1.08, 1.15]:
				
					print '\n-> Clusterizando dicionario com ' + str(np) \
						+ ', randomize centroids seeds ' + str(srndc) \
						+ ', eps ' + str(eps) \
						+ ', min_samples ' + str(sp);
					
					print '>>>>', (np, srndc, eps, sp);
					r = cluster.executarDBSCAN(dicionarioArquivo=dic, verbose=1, min_samples=sp, random_state=srndc, eps=eps);

					# Adiciona o resultado
					clusterResult[(np, srndc, eps, sp)] = r;

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
	print 'Melhor configuracao: ' + str(melhorConfiguracao) + str(clusterResultVt[-1]);
	print '---------------------------------------------------'
	print '\n\n\n\n\n'
	
	
# Executa processo de classificacao
def classificacao(dicionario):

	print 'Classificacao';
	
	for vizinhos in range(1,5):
	
		for np in [100, 200, 500]:
		
			# Obtem o dicionario
			dic = dicionario.obterDicionario(np);
		
			# Realiza a classificacao KNN
			print '\n\nClassificacao KNN para ' + str(vizinhos) + ' vizinhos e para dicionario de tamanho ' + str(np)			
			classificacao.knn(dic, vizinhos);
			
			# Realiza a classificacao KNN K-Fold
			print '\n\nClassificacao KNN K-Fold para ' + str(vizinhos) + ' vizinhos e para dicionario de tamanho ' + str(np)
			classificacao.kfold(dic, n_neighbors=vizinhos);
	
	
	for np in [100, 200, 500]:
		print '\n\nClassificacao Naive Baise para dicionario de tamanho ' + str(np)
		classificacao.NaiveBaise(dicionario.obterDicionario(np));

		
# Executar projeto
def executar():

	if len(sys.argv) < 2:
		print 'main.py -cluster para clusterizacao'
		print 'main.py -classif para classificacao'
		exit(1);

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
	
	if  'cluster' in sys.argv[1]:
	
		print '\n-> Criando Cluster...';
		cluster = Cluster(dicionario);
	
		# Realiza clusterizacao via K-Means
		clusterizacaoKmeans(dicionario, cluster);
		
		# Realiza clusterizacao via dbscan
		#clusterizacaoDBSCAN(dicionario, cluster);
	
	elif 'classif' in sys.argv[1]:
	
		# Reliza a classificacao
		classificacao(dicionario);
	

if __name__ == '__main__':
	executar();
