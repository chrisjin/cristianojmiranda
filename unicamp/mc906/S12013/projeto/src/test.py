import logging
from sklearn.feature_extraction import DictVectorizer
from dicionario import * 
from cluster import *;

# Configura log
logging.basicConfig(filename='../log/test.log',level=logging.DEBUG,format='%(asctime)s %(levelname)s %(message)s');

hp1 = {'a': 1, 'b': 2, 'c': 3};
hp2 = {'b': 20, 'c': 30};
hp3 = {'d': 40, 'c': 50};
Y = [hp1, hp2, hp3, {}];
print 'Y', Y;

dv = DictVectorizer(sparse=False)
X = dv.fit_transform(Y);
print 'X', X

dicionario = Dicionario();
cluster = Cluster();

#print dicionario.dicionarioPorMensagem['rec-motorcycles'];

print cluster.obterCentroidesIniciais(dicionario=dicionario, size=100, q='arq');
exit(1);


d = dicionario.obterDicionario(size=100, opt='ma');


print '\n\n\n\n\n\n\n';
print 'dicionario size=', len(d);
print 'dicionario[' + d.keys()[0] + ']=' + str(d[d.keys()[0]]);