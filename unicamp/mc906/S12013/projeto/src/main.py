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
	
	#print '\n-> Criando um dicionario com 100 palavras...'
	#dic100 = dicionario.obterDicionario(100);
	#dicionario.exibirDistribuicao(dic100);
	
	print '\n-> Criando um dicionario com 200 palavras...'
	#dic200 = dicionario.obterDicionario(200);
	#dicionario.exibirDistribuicao(dic200);
	
	print '\n-> Criando um dicionario com 500 palavras...'
	#dic500 = dicionario.obterDicionario(500);
	#dicionario.exibirDistribuicao(dic500);
	
	print '\n-> Criando um dicionario com todas as palavras processadas...'
	#dicFull = dicionario.obterDicionario(None);
	#dicionario.exibirDistribuicao(dicFull);
	
	dicionario.test();
	
	#cluster = Cluster();
	#cluster.executar(dicionario.dicionario);
	

if __name__ == '__main__':
	executar();