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
	dicionario = Dicionario();
	
	print '\n->Dicionario por tipo de mensagem'
	dicionario.exibirDistribuicao(dicionario.dicionarioPorMensagem);
	
	print '-> Criando Cluster...';
	cluster = Cluster();
	
	for np in [100]:#[100, 200, 500]:
	
		print '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++';
	
		print '\n-> Criando um dicionario com ' + str(np) + ' palavras...'
		dic = dicionario.obterDicionario(np, randomFlg=False);
		
		print '-> Clusterizando dicionario com ' + str(np) + ' palavras em 20 grupos';
		cluster.executarKmeans(dic, nrClusters=20);
	

if __name__ == '__main__':
	executar();
