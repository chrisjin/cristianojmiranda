import sys, itertools, math
from operator import itemgetter, attrgetter

from pygraph.classes.graph import graph
from pygraph.classes.digraph import digraph
from pygraph.algorithms.searching import *
from pygraph.readwrite.dot import write
from pygraph.algorithms.cycles import *

from collectionUtils import *
from graphUtils import *

print "====py steiner cycle====\n"
loadGraph("teste.scp")
#loadGraph("wrp3-30_no_leaf.scp")

if validaGrafo() == 1:
	
	# Criando o grafo
	gr = graph()
	
	# Adicionando os vertices
	gr.add_nodes(vertices)
	
	# Adicionando as arestas
	for key in arestas.iterkeys():
		gr.add_edge(key);
	
	#print "Depth first search rooted on node 1"
	#st, pre, post = depth_first_search(gr, root=1)
	#print st
	#print pre
	#print post
	
	# Draw graph
	#dot = write(gr)
	#file = open("graph.dot", "w");
	#file.write(dot);
	#file.close();
	
	#gst = digraph()
	#gst.add_spanning_tree(st)
	#dot = write(gst)
	#file = open("spanning_tree.dot", "w");
	#file.write(dot);
	#file.close();
	
	#print "\nBreadth first search rooted on node 1"
	#st, ord = breadth_first_search(gr, root=1)
	#print st
	#print ord
	
	cycle = find_cycle(gr)
	print "Ciclo:"
	print cycle

	
else:
	print "Grafo invalido"