from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.feature_extraction.text import TfidfTransformer

from sklearn.feature_extraction import DictVectorizer
from sklearn.feature_extraction import FeatureHasher

from sklearn import metrics

from sklearn.cluster import KMeans, MiniBatchKMeans

import logging
from optparse import OptionParser
import sys
from time import time

import numpy as np


class Cluster:

	# Imprime a clusterizacao
	def printCluster(self, dados, labels):

		print '\n\n - CLUSTERS'
		k = {};
		for i in range(len(dados)):

			if labels[i] not in k:
				k[labels[i]] = [];

			k[labels[i]].append(dados[i]);

		for i in k:
			print 'cluster: ' + str(i);
			for j in k[i]:
				print '\t - ' + str(j);
	
	# Imprime a clusterizacao e a percentagem de cada tipo de mensagem no cluster
	def printClusterStatistic(self, dados, labels):
		
		print '\n\n - CLUSTERS STATISTICS -'
		k = {};
		for i in range(len(dados)):

			if labels[i] not in k:
				k[labels[i]] = {};

			tp = dados[i][:dados[i].rindex('-')]
			
			if tp not in k[labels[i]]:
				k[labels[i]][tp] = 1.0;
			else:
				k[labels[i]][tp] += 1.0;

		for i in k:
			print '\n======================================================'
			print 'cluster: ' + str(i);
			for j in k[i]:
				#print '         ---------------------------------------------'
				print('\t - %s \t\t %.2f\n' % (j, (k[i][j]/reduce(lambda x, y: x + y, k[i].values(), 0))));
			#print '         ---------------------------------------------'
		print '======================================================'

		
	# Coloca um rotulo em cada tipo de arquivo, dando a clusterizacao esperada
	def clusterizacaoExperada(self, arquivos):
		
		clusterlb = [];
		
		for a in arquivos:
			tp = a[:a.rindex('-')]
			if tp not in clusterlb:
				clusterlb.append(tp);
				
		e = [];
		for a in arquivos:
			tp = a[:a.rindex('-')]
			e.append(clusterlb.index(tp));
			
		return e;
		
	# Executa o processo de clusterizacao usando kmeans
	def executarKMeans(self, dicionarioArquivo, nrClusters=20, verbose=0, featureExtraction=0, random_state=20, init='k-means++', miniBatch=True):
	
		print '\n\tClusterizando via K-Means ' + str(len(dicionarioArquivo)) + ' arquivos.';

		# Tempo de inicio da clusterizacao
		t0 = time()		
		
		# Matrix de clusterizacao
		X = [];
		
		# Vetor com apenas os arquivos a serem clusterizados em ordem
		arqVt = dicionarioArquivo.keys();
		
		# Feature extraction DictVectorizer
		if featureExtraction == 0:
				
			# Ajusta os dados
			dv = DictVectorizer(sparse=True)
			X = dv.fit_transform(dicionarioArquivo.values());
			
		# Feature extraction FeatureHasher
		if featureExtraction == 1:
			fh = FeatureHasher();
			X = fh.fit_transform(dicionarioArquivo.values());
		
		
		#logging.debug('X=' + str(X));		
		
		# Instancia kmeans
		if miniBatch:
			km = MiniBatchKMeans(n_clusters=nrClusters, init=init, max_iter=1000, n_init=3, verbose=verbose, random_state=random_state);
		else:
			km = KMeans(n_clusters=nrClusters, init=init, max_iter=1000, n_init=1, verbose=verbose, random_state=random_state);

		# Imprime a configuracao do KMeans
		if verbose == 1:
			print "Configuracao K-Means %s" % km
		
		# Clusteriza os dados
		km.fit(X)

		# Imprime o resultado
		#self.printCluster(arqVt, km.labels_);
		self.printClusterStatistic(arqVt, km.labels_);
		
		# Computa os resultados
		labels = self.clusterizacaoExperada(arqVt);
		
		ho = metrics.homogeneity_score(labels, km.labels_);
		co = metrics.completeness_score(labels, km.labels_);
		vm = metrics.v_measure_score(labels, km.labels_);
		ar = metrics.adjusted_rand_score(labels, km.labels_);
		
		# TODO: Verificar isso!
		#sc = metrics.silhouette_score(X, np.unique(labels));
		sc = 0.0;
		
		if verbose == 1:
			print "Homogeneity: %0.3f" % ho;
			print "Completeness: %0.3f" % co;
			print "V-measure: %0.3f" % vm;
			print "Adjusted Rand-Index: %.3f" % ar;
			print "Silhouette Coefficient: %0.3f" % sc;

		# Loga o tempo de clusterizacao
		logging.debug("Tempo de clusterizacao %fs" % (time() - t0))
		print
		
		return (ho, co, vm, ar, sc);
		
	# Obtem os centroides iniciais
	def obterCentroidesIniciais(self, dicionario, size):
	
		# Obtem dicionario por mensagem
		dpm = dicionario.dicionarioPorMensagem;
		
		# Obtem as 'size' palavras mais frequentes
		pf = dicionario.obterPalavrasMaisFrequentes(size);
		
		# Filtra em dpm as n palavras mais frequentes
		dpm_c = {};
		for ct in dpm:
		
			dpm_c[ct] = {};
			for p in dpm[ct]:
				if p in pf:
					dpm_c[ct][p] = dpm[ct][p];
		
		# Ajusta as medias
		for ct in dpm_c:
			for p in dpm_c[ct]:
					
					#nr_arq = int(len(dicionario.dicionarioPorArquivo) / len(dpm));
					nr_arq = 1.0 * len(dicionario.dicionarioPorArquivo) / len(dpm);
					#nr_arq = min(dpm_c[ct].values());
					
					dpm_c[ct][p] = int(dpm_c[ct][p] / nr_arq);
			
		
		#print 'Nr centroides:', len(dpm_c);
		#dicionario.exibirDistribuicao(dpm_c);
		
		#for i in range(1, 4):
		#	print '\ncentroides[centroides.keys()[i]]: ', dpm_c.keys()[i], dpm_c[dpm_c.keys()[i]];	
		
		dv = DictVectorizer(sparse=False)
		X = dv.fit_transform(dpm_c.values());
		
		return X;
		
