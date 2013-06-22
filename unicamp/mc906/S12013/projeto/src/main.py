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
	dicionario = Dicionario(ignoreBackup=True);
	
	print '\n-> Dicionario por tipo de mensagem'
	dicionario.exibirDistribuicao(dicionario.dicionarioPorMensagem);
	
	print '\n-> Criando Cluster...';
	cluster = Cluster();
	
	clstr = 3;
	ftr = 1;
	for np, nrCluster, feature in [(100, clstr, ftr), (200, clstr, ftr), (500, clstr, ftr)]:#[100, 200, 500]:
	
		print '\n++++++++++++++++++++++++++++';
	
		print '\n-> Criando um dicionario com ' + str(np) + ' palavras...'
		dic = dicionario.obterDicionario(np, randomFlg=False);
		
		print '\n-> Clusterizando dicionario com ' + str(np) + ' palavras em ' + str(nrCluster) + ' grupos, feature ' + str(feature);
		cluster.executarKMeans(dic, nrClusters=nrCluster, featureExtraction=feature);
	

if __name__ == '__main__':
	executar();
