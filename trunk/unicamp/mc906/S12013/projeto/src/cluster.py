from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.feature_extraction.text import TfidfTransformer

from sklearn.feature_extraction import DictVectorizer

from sklearn.pipeline import Pipeline
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
				#print '\t - ' + str(j) + ':  ' + str(k[i][j]);
				#print k[i][j], len(k[i]), reduce(lambda x, y: x + y, k[i].values(), 0)
				print('\t - %s \t\t %.3f\n' % (j, (k[i][j]/reduce(lambda x, y: x + y, k[i].values(), 0))));
			print '         ---------------------------------------------'
		print '======================================================'

		
		
	# Executa o processo de clusterizacao usando kmeans
	def executarKmeans(self, dicionarioArquivo, nrClusters=20, verbose=0, seeds=[], featureExtraction=0):
	
		print 'Clusterizando ' + str(len(dicionarioArquivo)) + ' arquivos.';

		t0 = time()
		
		X = [];
		
		# Feature extraction DictVectorizer
		if featureExtraction == 0:
			v = DictVectorizer(sparse=True)
			dp = []
			arqVt = []
			for arq in dicionarioArquivo:
				dp.append(dicionarioArquivo[arq]);
				arqVt.append(arq);

			X = v.fit_transform(dp);
		
		logging.debug('X=' + str(X));		
		
		# Instancia kmeans
		km = KMeans(n_clusters=nrClusters, init='k-means++', max_iter=1000, n_init=1, verbose=verbose);

		if verbose == 1:
			print "Configuracao K-Means %s" % km
		
		# Clusteriza os dados
		km.fit(X)

		# Imprime o resultado
		#self.printCluster(arqVt, km.labels_);
		self.printClusterStatistic(arqVt, km.labels_);

		logging.debug("Tempo de clusterizacao %fs" % (time() - t0))
		print
