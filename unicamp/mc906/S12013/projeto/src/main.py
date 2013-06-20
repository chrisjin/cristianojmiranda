import logging
from dicionario import *

def executar():

	# Configura o log
	logging.basicConfig(filename='../log/mc906.log',level=logging.DEBUG);

	print '\n\n\n\n\n'
	print '+---------------------------------------------+'
	print '| MC906 - Introducao a inteligencia artificial|'
	print '| Projeto                                     |'
	print '|---------------------------------------------|'
	print '| Alunos:                                     |' 
	print '|   Cristiano J. Miranda RA 083382            |'
	print '|   Fernando Massunari RA                     |'
	print '+---------------------------------------------+'
	print '\n\n\n\n\n'
	
	print '-> Criando dicionario...';
	dicionario = Dicionario();
	
	print '-> Criando um dicionario com 100 palavras...'
	dic100 = dicionario.obterDicionario(100);
	
	print '-> Criando um dicionario com 200 palavras...'
	dic200 = dicionario.obterDicionario(200);
	
	print '-> Criando um dicionario com 500 palavras...'
	dic500 = dicionario.obterDicionario(500);


if __name__ == '__main__':
	executar();