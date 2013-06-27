import sys
import logging
import numpy as np
from time import time

from sklearn import metrics

from sklearn.cluster import DBSCAN
from sklearn.cluster import KMeans, MiniBatchKMeans
from sklearn.feature_extraction import FeatureHasher
from sklearn.feature_extraction import DictVectorizer

class Cluster:

	centroideCache = {};

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

		c = [];
		kf = {};
		for i in k:
			print '\n======================================================'
			print 'cluster: ' + str(i);
			kf[i] = [];
			for j in k[i]:
				soma = reduce(lambda x, y: x + y, k[i].values(), 0);
				percent = k[i][j] / soma;
				print('\t - %s \t\t %.2f\n' % (j, percent));
				kf[i].append((j, percent));
				
			kf[i] = sorted(kf[i], key=lambda tup: tup[1])
			kf[i] = kf[i][-1];
			
			if kf[i][0] not in c:
				c.append(kf[i][0]);
			
		print '======================================================'
		print 'kf=' + str(kf);
		print 'c(' + str(len(c)) + '): ' + str(c);
		print '======================================================'
		return len(c);

		
	# Coloca um rotulo em cada tipo de arquivo, dando a clusterizacao esperada
	def clusterizacaoEsperada(self, arquivos):
		
		clusterlb = [];
		
		for a in arquivos:
			tp = a[:a.rindex('-')]
			if tp not in clusterlb:
				clusterlb.append(tp);
				
		e = [];
		for a in arquivos:
			tp = a[:a.rindex('-')]
			e.append(clusterlb.index(tp));
			
		logging.debug('Clusterizacao Esperada Size=' + str(len(e)));
		logging.debug('Clusterizacao Esperada=' + str(e));
		
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
			km = MiniBatchKMeans(n_clusters=nrClusters, init=init, max_iter=200, n_init=1, verbose=verbose, random_state=random_state);
		else:
			km = KMeans(n_clusters=nrClusters, init=init, max_iter=200, n_init=1, verbose=verbose, random_state=random_state);

		# Imprime a configuracao do KMeans
		if verbose == 1:
			print "Configuracao K-Means %s" % km
		
		# Clusteriza os dados
		km.fit(X)

		# Imprime o resultado
		#self.printCluster(arqVt, km.labels_);
		c = self.printClusterStatistic(arqVt, km.labels_);
		
		# Computa os resultados
		labels = self.clusterizacaoEsperada(arqVt);
		
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
		
		return (c, ho, co, vm, ar, sc);
		
	# Executa o processo de clusterizacao usando DBSCAN
	def executarDBSCAN(self, dicionarioArquivo, verbose=0, random_state=10, eps=.95):
	
		print '\n\tClusterizando via Mean Shift ' + str(len(dicionarioArquivo)) + ' arquivos.';

		# Tempo de inicio da clusterizacao
		t0 = time()		
		
		# Matrix de clusterizacao
		X = [];
		
		# Vetor com apenas os arquivos a serem clusterizados em ordem
		arqVt = dicionarioArquivo.keys();
		
		# Feature extraction DictVectorizer
		dv = DictVectorizer(sparse=False)
		X = dv.fit_transform(dicionarioArquivo.values());
		
		# Clusteriza os dados
		db = DBSCAN(eps=eps, min_samples=10, random_state=random_state);

		if verbose == 1:
			print db;

		db.fit(X)
		labels_ = db.labels_
		print 'labels: ', labels_

		# Imprime o resultado
		self.printClusterStatistic(arqVt, labels_);
		
		# Computa os resultados
		labels = self.clusterizacaoExperada(arqVt);
		
		ho = metrics.homogeneity_score(labels, labels_);
		co = metrics.completeness_score(labels, labels_);
		vm = metrics.v_measure_score(labels, labels_);
		ar = metrics.adjusted_rand_score(labels, labels_);
		
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
	def obterCentroidesIniciais(self, dicionario, size, flutuante=False, q='max', opt='mf'):
	
		logging.info('size=' + str(size));
		
		# Obtem do cache
		if size in self.centroideCache:
			return self.centroideCache[size];
		
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
		
			nr_arq = int(len(dicionario.dicionarioPorArquivo) / len(dpm));
			if flutuante:
				nr_arq = 1.0 * len(dicionario.dicionarioPorArquivo) / len(dpm);
			
			if q == 'min':
				nr_arq = min(dpm_c[ct].values());
			
			if q == 'max':
				nr_arq = max(dpm_c[ct].values());
		
			mf = [];
			# Obtem as 10% palavras mais frequentes dentro do grupo
			if opt == 'mf':
				z = zip(dpm_c[ct].keys(), dpm_c[ct].values());
				z = sorted(z, key=lambda tup: tup[1]);
				z.reverse();
				z = z[:int(.5*len(z))];
				for i in z:
					mf.append(i[0]);
				logging.debug('mf: ' + str(mf));
		
			for p in dpm_c[ct]:
				if opt == 'mf':
					dpm_c[ct][p] = 0;
					if p in mf:
						dpm_c[ct][p] = 1;
				else:
					dpm_c[ct][p] = int(dpm_c[ct][p] / nr_arq);
					if flutuante:
						dpm_c[ct][p] = dpm_c[ct][p] / nr_arq;
						
			if max(dpm_c[ct]) == 0:
				logging.warning('Cluster ' + ct + 'esta zerado!');
			
		
		logging.debug('Nr centroides:' + str(len(dpm_c)));
		logging.debug('Distribuicao: ');
		for k in dpm_c:
			logging.debug(k + ' - ' + str(len(dpm_c[k])));
		
		for i in range(len(dpm_c)):
			logging.debug('centroides[' + dpm_c.keys()[i] + ']: ' +  str(dpm_c[dpm_c.keys()[i]]));
		
		dv = DictVectorizer(sparse=False)
		X = dv.fit_transform(dpm_c.values());
		
		# Atualiza o cache
		self.centroideCache[size] = X;
		return X;