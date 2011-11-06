#ifndef ALG_EXATO_HPP
#define ALG_EXATO_HPP

#include <lemon/list_graph.h>
using namespace lemon;

/**
 * Solução exata para o fluxo do ciclo de Steiner.
 *
 */
class AlgExato {

public:

	AlgExato();

	// TODO: remover esse metodo!
	void roda();

	/**
	 * Algoritmo exato 1.
	 */
	void exato1(ListGraph *graph, ListGraph::NodeMap<bool> *terminal,
			ListGraph::EdgeMap<double> *length);

	int factorial(int n);

};

#endif  //ALG_EXATO_HPP
