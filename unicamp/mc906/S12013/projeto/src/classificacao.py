from os import walk
import logging
import time
import os.path
import pickle
import random
from threading import Thread
from sklearn.neighbors import KNeighborsClassifier
from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.feature_extraction.text import CountVectorizer
import logging
from cluster import *
from dicionario import *
import time
from sklearn.metrics import confusion_matrix
from sklearn import cross_validation
from numpy import *
import numpy
import numpy as np
from numpy.linalg import *
from sklearn.naive_bayes import MultinomialNB

class Classificacao:

############## Metodos do KNN #############

	# Extrai do nome do arquivo o tipo de mensagem
	def extrairTipoDeMensagem(self, fileName):
		return fileName[:fileName.rindex('-')];
	
	#separa os arquivos em treinamento (80%) e teste (20%)
		
	def separaGrupos (self,mp):
		#pega as chaves do mapa mp, que eh basicamente os nomes de todos os arquivos
		todosArquivos = mp.keys()
		result = {}
		treinamento = {}
		teste = {}
		#formata todos os nomes, armazenando tudo em result
		for a in todosArquivos:
			g = self.extrairTipoDeMensagem(a)
			if g in result:
				result[g].append(a)
			else:
				result[g] = [a]
		#randomiza o result e depois quebra ele em duas partes 80% e 20%
		for k in result:

			random.shuffle(result[k])
			random.shuffle(result[k])
			for j in result[k][:int(0.8*(len(result[k])))]:
				treinamento[j] = mp[j]
			for j in result[k][(int(0.8*len(result[k]))):]:
				teste[j] = mp[j]
				
		logging.debug(treinamento,teste)
		#retorna treinamento e teste
		return treinamento,teste
		
	#formata os grupos de treinamento e de teste, para utiliza-los no metodo knn

	def formata_TreinamentoTeste (self,mp):
		#separamos mp em treinamento e teste
		treinamento,teste = self.separaGrupos(mp)
		tabelaTreinamento = []
		tabelaTeste = []
		gruposIndexadosTreinamento = []
		gruposIndexadosTeste = []
		indices = []
		#a tabelaTreinamento contem os valores (nomes) e gruposIndexadosTreinamento
		#contem os labels de cada um dos valores 
		for nomeArquivo in treinamento:
			tp = nomeArquivo[:nomeArquivo.rindex('-')]
			tabelaTreinamento.append(treinamento[nomeArquivo])
			if nomeArquivo not in indices:
				indices.append(tp)
			gruposIndexadosTreinamento.append(indices.index(tp));				
		#a tabelaTeste contem os valores (nomes) e gruposIndexadosTreinamento
		#contem os labels de cada um dos valores, que utilizaremos para
		#comparar a nossa previsao com a resposta esperada
		for nomeArquivo in teste:
			tp = nomeArquivo[:nomeArquivo.rindex('-')]		
			tabelaTeste.append(teste[nomeArquivo])
			gruposIndexadosTeste.append(indices.index(tp));				

		#print tabelaTeste
		
		return tabelaTreinamento,gruposIndexadosTreinamento,tabelaTeste,gruposIndexadosTeste

	def knn(self, mp, n_neighbors=3):
		resultado = []
		count = 0
		#chama o classificador KNN
		neigh = KNeighborsClassifier(n_neighbors=n_neighbors, weights='distance')
		#pega as tabelas e labels, que serao utilizadas para o procedimento
		tabelaTreinamento,gruposIndexadosTreinamento,tabelaTeste,gruposIndexadosTeste = self.formata_TreinamentoTeste(mp)
		
		#transforma nossa tabela em um vetor
		dv = DictVectorizer(sparse=True)
		X = dv.fit_transform(tabelaTreinamento);
		neigh.fit(X,gruposIndexadosTreinamento)
		
		#rint tabelaTeste
		#transforma nossa tabela em um vetor
		Y = dv.fit_transform(tabelaTeste);		
		#resultado recebe a nossa predicao
		resultado = neigh.predict(Y)
	
		print resultado
		#conta nosso numero de acertos de grupos.
		for k in range(len(resultado)):
			if resultado[k] == gruposIndexadosTeste[k]:
				count+=1.0
		#printa a quantidade de acertos de acerto
		print "resultados = ", 1.0*count/len(resultado)
		
		print "confusion matrix:\n"
		
		#cria a matriz de confusao
		a = confusion_matrix(gruposIndexadosTeste, resultado)
		print confusion_matrix(gruposIndexadosTeste, resultado)
		count = 0
		acumulate = 0
		#para todos os elementos da diagonal, acumula eles e incrementa o contador
		for k in range(0,20):
			for j in range(0,20):
				if k==j:
					count+=1
					acumulate = 1.0*(acumulate + a[k][j])
		#calcula a media da diagonal				
		acumulate = acumulate/count
		
		print 'media da diagonal: ' + str(acumulate)
		print '\n\n'
		
		return count/len(resultado)

################# Metodos do KFold #################3

#pega indices do mapa mp - semelhante ao do KNN
	def pegaIndex(self,mp):
		tabelaArquivo = []
		indices = []
		gruposIndexados = []
	
		for nomeArquivo in mp:
			tp = nomeArquivo[:nomeArquivo.rindex('-')]
			# tabelaArquivo.append(mp[nomeArquivo])
			if nomeArquivo not in indices:
				indices.append(tp)
			gruposIndexados.append(indices.index(tp));
		
		return gruposIndexados

#formata teste e treinamento para o uso do KFold - semelhante ao do KNN

	def formata_TreinamentoTesteKFold (self,mp,treinamento,teste):
		tabelaTreinamento = []
		tabelaTeste = []
		gruposIndexadosTreinamento = []
		gruposIndexadosTeste = []
		indices = []
		#armazena valores na tabelaTreinamento e labels no gruposIndexadosTreinamento
		for nomeArquivo in treinamento:
			tp = nomeArquivo[:nomeArquivo.rindex('-')]
			tabelaTreinamento.append(mp[nomeArquivo])
			if nomeArquivo not in indices:
				indices.append(tp)
			gruposIndexadosTreinamento.append(indices.index(tp));				
		#armazena valores na tabelaTeste e labels no gruposIndexadosTreinamento
		for nomeArquivo in teste:
			tp = nomeArquivo[:nomeArquivo.rindex('-')]		
			tabelaTeste.append(mp[nomeArquivo])
			gruposIndexadosTeste.append(indices.index(tp));				

		return tabelaTreinamento,gruposIndexadosTreinamento,tabelaTeste,gruposIndexadosTeste


	def kfold(self, mp, n_neighbors=3):
		resultado = []
		count = 0
		neigh = KNeighborsClassifier(n_neighbors=n_neighbors, weights='distance')
		media_diagonal = []
		#alterar para kfold
		#tabelaTreinamento,gruposIndexadosTreinamento,tabelaTeste,gruposIndexadosTeste = self.formata_TreinamentoTeste(mp)
		
		X = np.array(mp.keys())
		
		y = self.pegaIndex(mp.keys())
		
		kf = cross_validation.KFold(len(X), n_folds=5)
		
		#faz 5 divisoes para treinamento/testes, e, nelas, vamos treinar os arquivos e depois testar o predict com os testes
		for train_index, test_index in kf:
			X_train, X_test = X[train_index], X[test_index]
			print("TRAIN:", train_index, "TEST:", test_index)
			print X_train
			tabelaTreinamento,gruposIndexadosTreinamento,tabelaTeste,gruposIndexadosTeste = self.formata_TreinamentoTesteKFold(mp,X_train,X_test)
			#X_train contem todos os nomes dos arquivos para teste
			#agora devemos treinar X
			
			dv = DictVectorizer(sparse=True)
			ALFA = dv.fit_transform(tabelaTreinamento)
			neigh.fit(ALFA,gruposIndexadosTreinamento)
			
			Y = dv.fit_transform(tabelaTeste);		
			#resultado recebe a nossa predicao
			resultado = neigh.predict(Y)
	
			print resultado
			#conta nosso numero de acertos de grupos.
			for k in range(len(resultado)):
				if resultado[k] == gruposIndexadosTeste[k]:
					count+=1.0
			#printa a quantidade de acertos de acerto
			print "resultados = ", 1.0*count/len(resultado)
		
			print "confusion matrix:\n"
			#confusion matrix
			a = confusion_matrix(gruposIndexadosTeste, resultado)
			print confusion_matrix(gruposIndexadosTeste, resultado)
			count = 0
			acumulate = 0
			#calculamos a somatoria da diagonal
			for k in range(0,20):
				for j in range(0,20):
					if k==j:
						count+=1
						acumulate = 1.0*(acumulate + a[k][j])
			#media da diagonal
			acumulate = acumulate/count
			
			media_diagonal.append(acumulate)
			
			print 'media da diagonal: ' + str(acumulate)
			print '\n'

		acumulate = 0
		
		for i in media_diagonal:
			acumulate = acumulate + i
		#calculamos o desvio padrao e a media final de todos os folds
		acumulate = acumulate/len(media_diagonal)
		print 'desvio padrao: ',std(media_diagonal)
		
		print 'media final: ', acumulate
		
			#return count/len(resultado)



	def NaiveBaise(self, mp):
		resultado = []
		count = 0
		tabelaTreinamento,gruposIndexadosTreinamento,tabelaTeste,gruposIndexadosTeste = self.formata_TreinamentoTeste(mp)
		
		dv = DictVectorizer(sparse=True)
		X = dv.fit_transform(tabelaTreinamento);
		neigh = MultinomialNB().fit(X, gruposIndexadosTreinamento)
		
		#rint tabelaTeste
		
		Y = dv.fit_transform(tabelaTeste);		
		#resultado recebe a nossa predicao
		resultado = neigh.predict(Y)
	
		print resultado
		#conta nosso numero de acertos de grupos.
		for k in range(len(resultado)):
			if resultado[k] == gruposIndexadosTeste[k]:
				count+=1.0
		#printa a quantidade de acertos de acerto
		print "resultados = ", 1.0*count/len(resultado)
		
		print "confusion matrix:\n"
		
		a = confusion_matrix(gruposIndexadosTeste, resultado)
		print confusion_matrix(gruposIndexadosTeste, resultado)
		count = 0
		acumulate = 0
		for k in range(0,20):
			for j in range(0,20):
				if k==j:
					count+=1
					acumulate = acumulate + a[k][j]
						
		acumulate = acumulate/count
		
		print 'media da diagonal: ' + str(acumulate)
		print '\n\n'
		
		return count/len(resultado)
