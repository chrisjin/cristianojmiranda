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

class Classificacao:
	# Extrai do nome do arquivo o tipo de mensagem
	def extrairTipoDeMensagem(self, fileName):
		return fileName[:fileName.rindex('-')];
		
	def separaGrupos (self,mp):
		todosArquivos = mp.keys()
		result = {}
		treinamento = {}
		teste = {}
		for a in todosArquivos:
			g = self.extrairTipoDeMensagem(a)
			if g in result:
				result[g].append(a)
			else:
				result[g] = [a]
		for k in result:
			random.shuffle(result[k])
			random.shuffle(result[k])
			random.shuffle(result[k])
			random.shuffle(result[k])
			random.shuffle(result[k])
			random.shuffle(result[k])
			for j in result[k][:int(0.8*(len(result[k])))]:
				treinamento[j] = mp[j]
			for j in result[k][(int(0.8*len(result[k]))):]:
				teste[j] = mp[j]
				
		logging.debug(treinamento,teste)
		
		return treinamento,teste
		


	def formata_TreinamentoTeste (self,mp):
		treinamento,teste = self.separaGrupos(mp)
		tabelaTreinamento = []
		tabelaTeste = []
		gruposIndexadosTreinamento = []
		gruposIndexadosTeste = []
		indices = []

		for nomeArquivo in treinamento:
			tp = nomeArquivo[:nomeArquivo.rindex('-')]
			tabelaTreinamento.append(treinamento[nomeArquivo])
			if nomeArquivo not in indices:
				indices.append(tp)
			gruposIndexadosTreinamento.append(indices.index(tp));				

		for nomeArquivo in teste:
			tp = nomeArquivo[:nomeArquivo.rindex('-')]		
			tabelaTeste.append(teste[nomeArquivo])
			gruposIndexadosTeste.append(indices.index(tp));				

		#print tabelaTeste
		
		return tabelaTreinamento,gruposIndexadosTreinamento,tabelaTeste,gruposIndexadosTeste

	def knn(self, mp):
		resultado = []
		count = 0
		neigh = KNeighborsClassifier(n_neighbors=3,weights='distance')
		tabelaTreinamento,gruposIndexadosTreinamento,tabelaTeste,gruposIndexadosTeste = self.formata_TreinamentoTeste(mp)
		# Ajusta os dados
		dv = DictVectorizer(sparse=True)
		X = dv.fit_transform(tabelaTreinamento);
		neigh.fit(X,gruposIndexadosTreinamento)
		
		#rint tabelaTeste
		
		Y = dv.fit_transform(tabelaTeste);		
		
		resultado = neigh.predict(Y)

		print resultado

		for k in range(len(resultado)):
			if resultado[k] == gruposIndexadosTeste[k]:
				count+=1.0
		
		print "resultados = ", 1.0*count/len(resultado)
		
		return count/len(resultado)
