#include <iostream>
#include <sstream>
#include "algExato.hpp"
#include <stdio.h>
#include <stdlib.h>

#include <lemon/bfs.h>
#include <lemon/list_graph.h>
#include <lemon/dijkstra.h>
#include <lemon/lgf_writer.h>
#include <lemon/bfs.h>

using namespace std;
using namespace lemon;

AlgExato::AlgExato() {
}

void AlgExato::roda() {
	cout << "\n\n---| rodando AlgExato::roda()" << endl;
}

/**
 *
 */
void AlgExato::exato1(ListGraph *graph, ListGraph::NodeMap<bool> *terminal,
		ListGraph::EdgeMap<double> *length) {

	cout << "\n\n---| rodando AlgExato::exato1() |---" << endl;

	// Monta um vetor de termais que sera utilizado para trazer o ciclo
	cout << "Montando vetor de terminais..." << endl;
	std::vector<ListGraph::Node> terminais;
	for (ListGraph::NodeIt v(*graph); v != INVALID; ++v) {
		cout << graph->id(v);
		if ((*terminal)[v]) {
			cout << " - Terminal!";
			terminais.push_back(v);
		}

		cout << endl;
	}

	cout << "---- executando BFS ----" << endl << endl;

	std::vector<ListGraph::Node> result;
	result.push_back(terminais[0]);

	Bfs<ListGraph> bfs(*graph);

	std: vector<ListGraph::Node> nodeMenores;
	for (unsigned int i = 0; i < terminais.size(); i++) {

		cout << "Executando BFS para o node: " << graph->id(terminais[i])
				<< "..." << endl;
		bfs.run(terminais[i]);

		bool insert = false;
		double distanciaMenor = 999999999;
		nodeMenores.clear();

		for (unsigned int j = 0; j < terminais.size(); j++) {

			if (terminais[i] != terminais[j]) {

				cout << "Processando path " << graph->id(terminais[i])
						<< " ate " << graph->id(terminais[j]) << endl;

				cout << "Verificando se o node ja faz parte da resposta..."
						<< endl;
				bool resultContem = false;
				for (unsigned int k = 0; k < result.size(); k++) {
					if (terminais[j] == result[k]) {

						cout << "Node " << graph->id(terminais[j])
								<< " ja foi computado. Verificando proximo..."
								<< endl;
						resultContem = true;
						break;
					}
				}

				if (!resultContem && bfs.reached(terminais[j])) {

					insert = true;

					cout << endl << endl << "Dist: " << bfs.dist(terminais[j]) << endl << endl;

					if (bfs.dist(terminais[j]) == 1) {

						cout << "Existe uma aresta entre "
								<< graph->id(terminais[i]) << " e "
								<< graph->id(terminais[j]) << endl;

						cout << "Searching edge..." << endl;

						ListGraph::IncEdgeIt e(*graph, terminais[i]);
						for (; e != INVALID; ++e) {
							if ((graph->u(e) == terminais[j])
									|| (graph->v(e) == terminais[j]))
								break;
						}

						if (e != INVALID) {
							cout << "Aresta encontrada!" << (*length)[e]
									<< endl;

							if (distanciaMenor > (*length)[e]) {
								distanciaMenor = (*length)[e];
								nodeMenores.clear();
								nodeMenores.push_back(terminais[j]);
							}

						} else {
							cout << endl << "ATENCAO! - Aresta nao encontrada."
									<< endl << endl;
						}

					} else {

						cout << endl << endl << "---------------------------"
								<< endl;
						cout << "Existe um caminho entre "
								<< graph->id(terminais[i]) << " e "
								<< graph->id(terminais[j])
								<< ", calculando distancia..." << endl;

						std::vector<ListGraph::Node> tmpNode;

						ListGraph::Node n1 = terminais[j];
						ListGraph::Node n2 = bfs.predNode(n1);

						tmpNode.clear();
						tmpNode.push_back(n1);

						double tmpDist = 0;

						while (n2 != INVALID) {

							ListGraph::IncEdgeIt e(*graph, n1);
							for (; e != INVALID; ++e) {
								if (graph->u(e) == n2 || graph->v(e) == n2) {
									break;
								}
							}

							if (e != INVALID) {

								cout << endl << endl;
								cout << "Aresta encontrada!" << (*length)[e]
										<< endl;

								tmpDist = tmpDist + (*length)[e];
								tmpNode.push_back(n2);

							}

							n2 = bfs.predNode(n2);
							n1 = n2;
						}

						cout << "TmpDist: " << tmpDist << endl;
						if (distanciaMenor > tmpDist && tmpNode.size() > 0) {
							distanciaMenor = tmpDist;
							nodeMenores.clear();

							for (unsigned int n = 0; n < tmpNode.size(); n++) {
								nodeMenores.push_back(tmpNode[n]);
							}

							tmpNode.clear();

						}

					}

				}
			}

		}

		if (insert) {

			if (distanciaMenor != 999999999) {

				for (unsigned int n = 0; n < nodeMenores.size(); n++) {
					result.push_back(nodeMenores[n]);
				}

				nodeMenores.clear();

			} else {
				cout << endl << endl << "OPS! - Nao existe ciclo!!!!";
				return;
			}
		}

	}

	cout << "Path-----------------------" << endl;

	double distancia = 0;

	for (int k = 0; k < result.size(); k++) {
		cout << graph->id(result[k]) << " -> ";
	}
	cout << graph->id(result[0]);

	cout << endl << "Calculando distancia..." << endl;

	for (int k = 0; k < result.size(); k++) {

		int j = 0;
		if (k != result.size() - 1) {
			j = k + 1;
		}

		cout << endl << "k: " << k << ", j: " << j;
		cout << ", node[k]: " << graph->id(result[k]);
		cout << ", node[j]: " << graph->id(result[j]);

		ListGraph::IncEdgeIt e(*graph, result[k]);
		for (; e != INVALID; ++e) {
			if ((graph->u(e) == result[j]) || (graph->v(e) == result[j])) {
				break;
			}
		}

		if (e != INVALID) {
			cout << ", distancia: " << (*length)[e] << endl;
			distancia = distancia + (*length)[e];
		}

	}

	cout << endl;
	cout << "Distancia: " << distancia << endl;

	cout << "Sucesso......" << endl;

	for (ListGraph::NodeIt n(*graph); n != INVALID; ++n) {
		if (bfs.reached(n) && bfs.dist(n) <= 20) {
			std::cout << graph->id(n);
			ListGraph::Node prev = bfs.predNode(n);
			while (prev != INVALID) {
				std::cout << "<-" << graph->id(prev);
				prev = bfs.predNode(prev);
			}
			std::cout << std::endl;
		}
	}

}

int AlgExato::factorial(int n) {
	return (n == 0) ? 1 : n * factorial(n - 1);
}

