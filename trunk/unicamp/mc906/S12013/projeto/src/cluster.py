from sklearn.datasets import fetch_20newsgroups
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
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

	def executar(self, dataset, labels=[]):

		###############################################################################
		# Load some categories from the training set
		categories = [
			'alt.atheism',
			'talk.religion.misc',
			'comp.graphics',
			'sci.space',
		]
		# Uncomment the following to do the analysis on all the categories
		#categories = None

		print "Loading 20 newsgroups dataset for categories:"
		print categories

		#dataset = fetch_20newsgroups(subset='all', categories=categories, shuffle=True, random_state=42)

		#print "%d documents" % len(dataset.data)
		print "%d documents" % len(dataset)
		#print "%d categories" % len(dataset.target_names)
		print

		#labels = dataset.target
		#true_k = np.unique(labels).shape[0]
		true_k = 20

		print "Extracting features from the training dataset using a sparse vectorizer"
		t0 = time()
		vectorizer = TfidfVectorizer(max_df=0.5, max_features=10000,stop_words='english', use_idf=True);
		#X = vectorizer.fit_transform(dataset.data)
		X = vectorizer.fit_transform(dataset)

		print "done in %fs" % (time() - t0)
		print "n_samples: %d, n_features: %d" % X.shape
		print


		###############################################################################
		# Do the actual clustering
		km = KMeans(n_clusters=true_k, init='k-means++', max_iter=100, n_init=1, verbose=1)

		print "Clustering sparse data with %s" % km
		t0 = time()
		km.fit(X)
		print "done in %0.3fs" % (time() - t0)
		print

		print "Homogeneity: %0.3f" % metrics.homogeneity_score(labels, km.labels_)
		print "Completeness: %0.3f" % metrics.completeness_score(labels, km.labels_)
		print "V-measure: %0.3f" % metrics.v_measure_score(labels, km.labels_)
		print "Adjusted Rand-Index: %.3f" % \
			metrics.adjusted_rand_score(labels, km.labels_)
		print "Silhouette Coefficient: %0.3f" % metrics.silhouette_score(
			X, labels, sample_size=1000)

		print