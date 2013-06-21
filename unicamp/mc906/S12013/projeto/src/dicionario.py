from os import walk
import logging
import time
import os.path
import pickle
import random
from threading import Thread

# Dicionario
class Dicionario:

	# Tokens a serem removidos
	IGNORE_TOKEN = [',', '.', ':', "'", '"', '?', '@', '!', '&', '*', '(', ')', '$', '%', '+', '-', '_', ';', '{', '}', '[', ']', '=', '#', '\\', '/', '|', '<', '>', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
	
	# Arquivo de backup
	BACKUP_FILE = 'dicionario.bkp';
	
	SLEEP_TIME_S = 1; # 60;
	NR_THREADS = 200;

	# Lista com palavras a serem ignoradas
	stopWords = [];
	
	# Dicionario de palavras
	dicionario = [];
	
	# Dicionario por tipo de mensagem
	dicionarioPorMensagem = {};

	# Extrai do nome do arquivo o tipo de mensagem
	def extrairTipoDeMensagem(self, fileName):
		return fileName[fileName.rindex('/') + 1:fileName.rindex('-')];
		
	
	# Carrega o vetor de palavras a serem ignoradas
	def loadStopWords(self, stopWordsPath):
		
		arq = open(stopWordsPath, 'r');
		for l in arq.readlines():
			self.stopWords.append(l.strip());
			
		arq.close();
		logging.debug("stopWords: " + str(self.stopWords));
	
	def clearLine(self, line):
		tmp = line;
		for t in self.IGNORE_TOKEN:
			tmp = tmp.replace(t, ' ');
		
		return tmp;
	
	# Processa cada um dos arquivos individualmente
	def processarArquivo(self, arquivo):
		
		# tempo inicial para processar um arquivo
		inicio = time.time();
		logging.debug('processando arquivo: ' + arquivo);
		f = open(arquivo, 'r');
		
		# Obtem o tipo de mensagem
		mensagem = self.extrairTipoDeMensagem(arquivo);

		# Cria o dicionario por mensagem
		if mensagem not in self.dicionarioPorMensagem:
			self.dicionarioPorMensagem[mensagem] = {};
		
		# Obtem o dicionario por tipo de mensagem
		dpm = self.dicionarioPorMensagem[mensagem];
		
		# Le o arquivo linha a linha
		for l in f.readlines():
		
			# Obtem todas as palavras da linha
			palavras = self.clearLine(l).strip().split(' ');
			for p in palavras:
			
				# Verifica se a palavra deve ser considerada
				if p.lower() not in self.stopWords:
					if p.lower() not in self.dicionario and len(p.strip()) > 0:
						self.dicionario.append(p.lower());
				
				# Atualiza o contador de palavra por tipo de mensagem
				if p in dpm:
					dpm[p] += 1;
				else:
					dpm[p] = 1;
				

		f.close();
		fim = time.time();
		logging.debug('Tempo para processar um arquivo: ' + str(fim - inicio) + 's');
	
	def finalizouThreads(self, tds):
		for ti in tds:
			if ti.isAlive():
				return False;
				
		return True;
	
	# Processa o diretorio com os arquivos de mensagens
	def processarMensagens(self, messagesPath):
		for (dirpath, dirnames, filenames) in walk(messagesPath):
		
			count = 0;
			tds = [];
			
			for filename in filenames:
				count += 1;
				logging.info(' procesando arquivo ' + str(count) + ' de ' + str(len(filenames)));
				#self.processarArquivo(dirpath + '/' + filename);
				t = Thread(target=self.processarArquivo, args=(dirpath + '/' + filename,));
				t.start();
				tds.append(t);
			
				if len(tds) == self.NR_THREADS:
					while not self.finalizouThreads(tds):
						time.sleep(self.SLEEP_TIME_S);
					tds = [];
					
			while not self.finalizouThreads(tds):
				time.sleep(self.SLEEP_TIME_S);

		logging.debug('dicionario: ' + str(self.dicionario));
	
	def loadBackup(self, backupDir):
	
		logging.info('Recarregando backup');
		filename = backupDir + self.BACKUP_FILE;
		if (os.path.exists(filename)):
			f = open(filename, 'rb');
			d = pickle.load(f);
			
			# Volta o backup
			self.dicionario = d[0];
			self.dicionarioPorMensagem = d[1];
			
			f.close();
		
	def backup(self, backupDir):
		f = open(backupDir + self.BACKUP_FILE, 'wb');
		
		d = [self.dicionario, self.dicionarioPorMensagem];
		pickle.dump(d, f);
		
		f.close();
		
		logging.info('Backup salvo');
	
	# Construtor da classe
	def __init__(self, stopWordsPath='../stopwords/english', messagesPath='../_messages', backupDir='../backup/'):

		# Inicio do processamento
		inicio = time.time();
		
		# Carrega o backup
		self.loadBackup(backupDir);
		
		# Verifica se o backupe foi de fato carregado
		if len(self.dicionario) == 0:
		
			# Carrega a lista de palavras a serem ignoradas
			self.loadStopWords(stopWordsPath);
			
			# Monta o dicionario a partir do diretorio de mensagens
			self.processarMensagens(messagesPath);
			
			# Salva o backup, para nao ter que processar todas as mensagens varias vezes
			self.backup(backupDir);
			
		else:
			logging.info('Backup reestabelecido.');
	
		# Obtem o fim do processamento
		fim = time.time();
		logging.debug('Tempo de processamento do dicionario ' + str(fim - inicio) + 's');
		
	def dicionarioValido(self, mp):
	
		for k in mp:
			if len(mp[k]) == 0:
				return False;
		
		return True;
	
	def obterDicionario(self, size=100):
	
		mp = {'x': {}};
		while not self.dicionarioValido(mp):
			
			for i in range(1, random.randint(10, 50)):
				random.shuffle(self.dicionario);
				
			d = self.dicionario[:size];
			mp = {};
			
			for k in self.dicionarioPorMensagem:
				mp[k] = {};
				
				for i in self.dicionarioPorMensagem[k]:
					if i in d:
						mp[k][i] = self.dicionarioPorMensagem[k][i];
						
		return mp;