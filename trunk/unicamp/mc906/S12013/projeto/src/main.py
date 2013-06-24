import logging
from cluster import *
from dicionario import *
import time


# Executa o processo de custerizacao para um configuracao de K-Means
def clusterizar(np, c, srndc, kmeansInit, clusterResult, mnbtch, dicionario, cluster):
	
	print '\n-> Criando um dicionario com ' + str(np) + ' palavras...'
	dic = dicionario.obterDicionario(np, randomFlg=False);
		
	print '\n-> Clusterizando dicionario com ' + str(np) + ' palavras em ' \
			+ str(c) + ' grupos, randomize centroids seeds ' + str(srndc) + ', kmeansInit ' + str(kmeansInit);
					
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
	for np in [100, 200, 500]:
	
		# Seeds para randomizar centroides
		for srndc in [None, 100, 1000]:
		
			# Nr de clusters
			for c in [20]:
	
				# Altera a maneira de escolher os centroides
				for kmeansInit in ['k-means++', 'random', 'ndarray']:

					# A clusterizacao via minibatch kmeans demonstrou boms resultados
					clusterizar(np, c, srndc, kmeansInit, clusterResult, True, dicionario, cluster);
					
	
	print 'Tempo total para clusterizacao: ' + str(time.time() - t0cluster) + 's';
	
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
	
	print '\n\n\n\n\n'
	print '---------------------------------------------------'
	print 'Melhor configuracao: ' + str(melhorConfiguracao);
	print '---------------------------------------------------'
	
	# realiza a melhor clusterizacao novamente
	clusterizar(melhorConfiguracao[0], melhorConfiguracao[2], melhorConfiguracao[1], melhorConfiguracao[3], {}, melhorConfiguracao[4], dicionario, cluster)
	
def clusterizacaoSpectralClustering(dicionario, cluster):
	
	print '\n-> SpectralClustering';
	
	print '\n-> Criando um dicionario com 100 palavras...'
	dic = dicionario.obterDicionario(100);
	
	print cluster.executarSpectralClustering(dicionarioArquivo=dic, verbose=1);
	
	
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
	
	# Realiza clusterizacao via K-Means
	clusterizacaoKmeans(dicionario, cluster);
	
	# Realiza clusterizacao via Spectral 
	#clusterizacaoSpectralClustering(dicionario, cluster);
	
	# Reliza a classificacao
	#classificacao();
	
	

if __name__ == '__main__':
	executar();