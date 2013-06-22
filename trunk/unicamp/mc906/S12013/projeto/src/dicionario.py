from os import walk
import logging
import time
import os.path
import pickle
import random
from threading import Thread

from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.feature_extraction.text import CountVectorizer

# Dicionario
class Dicionario:

	# Tokens a serem removidos
	IGNORE_TOKEN = [',', '.', ':', "'", '"', '?', '@', '!', '&', '*', '(', ')', '$', '%', '+', '-', '_', ';', '{', '}', '[', ']', '=', '#', '\\', '/', '|', '<', '>', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '~', '^', '\n', '\t', '\r', '`'];
	
	# Arquivo de backup
	BACKUP_FILE = 'dicionario.bkp';
	
	# Tempo para esperar um grupo de thread executar
	SLEEP_TIME_S = 1.5;
	
	# Nr de threads para leitura dos arquivos
	NR_THREADS = 800;#700;

	# Lista com palavras a serem ignoradas
	stopWords = [];
	
	# Dicionario de palavras
	dicionario = {};
	
	# Dicionario por tipo de mensagem
	dicionarioPorMensagem = {};

	# Dicionario por arquivo
	dicionarioPorArquivo = {};

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
		
		# Cria o dicionario por arquivo
		arq = arquivo[arquivo.rindex('/')+1:];
		if arq not in self.dicionarioPorArquivo:
			self.dicionarioPorArquivo[arq] = {};
		
		# Obtem o dicionario por tipo de arquivo
		dpa = self.dicionarioPorArquivo[arq];
		
		# Le o arquivo linha a linha
		for l in f.readlines():
		
			# Obtem todas as palavras da linha
			palavras = self.clearLine(l).strip().split(' ');
			for p in palavras:
			
				p = p.lower().strip();
			
				# Verifica se a palavra deve ser considerada
				if p not in self.stopWords:
					if len(p) > 0:
						if p in self.dicionario:
							self.dicionario[p] += 1;
						else:
							self.dicionario[p] = 1;
				
					# Atualiza o contador de palavra por tipo de mensagem
					if p in dpm:
						dpm[p] += 1;
					else:
						dpm[p] = 1;

					if p in dpa:
						dpa[p] += 1;
					else:
						dpa[p] = 1;						

		f.close();
		fim = time.time();
		logging.debug('Tempo para processar um arquivo: ' + str(fim - inicio) + 's');
	
	# Verifica se o grupo de threads finalizou
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
				
				# Dispara thread para processar o arquivo
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
	
	# Obtem o backup do arquivo para a memoria
	def loadBackup(self, backupDir):
	
		logging.info('Recarregando backup');
		filename = backupDir + self.BACKUP_FILE;
		if (os.path.exists(filename)):
			f = open(filename, 'rb');
			d = pickle.load(f);
			
			# Volta o backup
			self.dicionario = d[0];
			self.dicionarioPorMensagem = d[1];
			self.dicionarioPorArquivo = d[2];
			
			f.close();
		
	# Salva o backup da memoria para o arquivo
	def backup(self, backupDir):
		f = open(backupDir + self.BACKUP_FILE, 'wb');
		
		d = [self.dicionario, self.dicionarioPorMensagem, self.dicionarioPorArquivo];
		pickle.dump(d, f);
		
		f.close();
		
		logging.info('Backup salvo');
	
	# Construtor da classe
	def __init__(self, stopWordsPath='../stopwords/english', messagesPath='../messages', backupDir='../backup/', ignoreBackup=False):

		# Inicio do processamento
		inicio = time.time();
		
		# Carrega o backup
		if not ignoreBackup:
			self.loadBackup(backupDir);
		
		# Verifica se o backupe foi de fato carregado
		if len(self.dicionario) == 0:
		
			# Carrega a lista de palavras a serem ignoradas
			self.loadStopWords(stopWordsPath);
			
			# Monta o dicionario a partir do diretorio de mensagens
			self.processarMensagens(messagesPath);
			
			# Salva o backup, para nao ter que processar todas as mensagens varias vezes
			self.backup(backupDir);

			print 'self.dicionarioPorArquivo: ' + str(len(self.dicionarioPorArquivo));
			
		else:
			logging.info('Backup reestabelecido.');
	
		# Obtem o fim do processamento
		fim = time.time();
		logging.debug('Tempo de processamento do dicionario ' + str(fim - inicio) + 's');

	#		
	def dicionarioValido(self, mp):
	
		logging.info('Verificando validade dicionario...');
		for k in mp:
			if len(mp[k]) == 0:
				logging.info('Dicionario invalido');
				return False;
		
		logging.info('Dicionario valido');
		return True;
	
	# Obtem o dicionario completo por arquivo
	def obterDicionario(self, size=100, randomFlg=False, normalizar=False):

		# Retonar o dicionario completo
		if size == None:
			return self.dicionarioPorArquivo;

		mp = {};
		palavras = [];
		
		# Obtem amostragem aleatoria
		if randomFlg:
			
			mp = {'x': {}};
			while not self.dicionarioValido(mp):
					
				# Randomiza o dicionario
				palavras = list(self.dicionario.keys());
				for i in range(1, random.randint(10, 50)):
					random.shuffle(palavras);
					
				# Obtem todas as palavras
				palavras = palavras[:size];
				mp = {};
					
				for k in self.dicionarioPorArquivo:
						mp[k] = {};			
						for i in self.dicionarioPorArquivo[k]:
								if i in palavras:
									mp[k][i] = self.dicionarioPorArquivo[k][i];
		
		# Obtem amostragem mais frequente
		else:
		
			# Monta a lista de palavras
			tuplaPalavras = []
			for k in self.dicionario:
				tuplaPalavras.append((k, self.dicionario[k]));

			# Ordena pela frequencia
			tuplaPalavras = sorted(tuplaPalavras, key=lambda tup: tup[1])
			tuplaPalavras.reverse();
			tuplaPalavras = tuplaPalavras[:size];
			
			logging.debug('Tuplas mais frequentes: ' + str(tuplaPalavras));
			
			for i in tuplaPalavras:
				palavras.append(i[0]);

			for k in self.dicionarioPorArquivo:
				for i in self.dicionarioPorArquivo[k]:
					if i in palavras:
						if k not in mp:
							mp[k] = {};

						mp[k][i] = self.dicionarioPorArquivo[k][i];
						
				# Verifica se o arquivo ficou fora do map
				if k not in mp or len(mp[k]) == 0:
					logging.warning("Atencao, o arquivo " + str(k) + " foi ignorado");

		# Normaliza o dicionario de palavras para que todas as palavras estejam em todos os arquivos 
		if normalizar:
			for ka in mp:
				for k in palavras:
					if k not in mp[ka]:
						mp[ka][k] = 0;

		return mp;
		
	def exibirDistribuicao(self, dic):
		for k in dic:
			print k + ' - ' + str(len(dic[k]));