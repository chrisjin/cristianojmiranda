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


'''
	Referencia: http://scikit-learn.org/stable/auto_examples/document_clustering.html#example-document-clustering-py
'''

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
				print '         ---------------------------------------------'
				print('\t - %s \t\t %.2f\n' % (j, (k[i][j]/reduce(lambda x, y: x + y, k[i].values(), 0))));
			print '         ---------------------------------------------'
		print '======================================================'

		
		
	# Executa o processo de clusterizacao usando kmeans
	def executarKMeans(self, dicionarioArquivo, nrClusters=20, verbose=0, seeds=[], featureExtraction=0):
	
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
		
		
		logging.debug('X=' + str(X));		
		
		# Instancia kmeans
		km = KMeans(n_clusters=nrClusters, init='k-means++', max_iter=1000, n_init=1, verbose=verbose);

		# Imprime a configuracao do KMeans
		if verbose == 1:
			print "Configuracao K-Means %s" % km
		
		# Clusteriza os dados
		km.fit(X)

		# Imprime o resultado
		#self.printCluster(arqVt, km.labels_);
		self.printClusterStatistic(arqVt, km.labels_);

		# Loga o tempo de clusterizacao
		logging.debug("Tempo de clusterizacao %fs" % (time() - t0))
		print
