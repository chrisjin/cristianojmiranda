/******************************************************************************
 * RA083382.cpp: Implementation for My Steiner Cycle Solver class.
 *
 * Author: Cristaino J. Miranda <cristianojmiranda@gmail.com>
 *
 * (c) Copyright 2011 Institute of Computing, University of Campinas.
 *     All Rights Reserved.
 *
 *  Created on : Oct 01, 2011 by andrade
 *  Last update: Oct 02, 2011 by andrade
 *
 * This software is licensed under the Common Public License. Please see
 * accompanying file for terms.
 *****************************************************************************/

#include <iostream>
using namespace std;

#include <lemon/list_graph.h>
using namespace lemon;

#include "RA083382.hpp"
#include "../mtrand.hpp"

//-------------------------[ Default Construtor ]----------------------------//

// N�O SE ESQUE�A DE CHAMAR O CONSTRUTOR DA CLASSE BASE EM PRIMEIRO LUGAR
RA083382::RA083382(): SteinerCycleSolver(),
    ze() {}

//-------------------------[ Default Destructor ]----------------------------//

RA083382::~RA083382() {}

//-----------------------------[ Set Instance ]------------------------------//

// Se for sobrecarregar esta fun��o, tome cuidado de limpar o grafo antigo.
// Recomendo chamar o m�todo da classe base primeiro.
bool RA083382::loadInstance(const char* filename) {
    return SteinerCycleSolver::loadInstance(filename);
}

//--------------------------------[ Solve ]----------------------------------//

RA083382::ResultType RA083382::solve(const double max_time) {
    cout << "\n--> Resolvendo por um super-ultra-mega-hiper algoritmo doidao em "
         << max_time << " segundos."
         << endl;

    return RA083382::EXACT_NO_SOLUTION;
}

//--------------------------------[ Solve ]----------------------------------//

RA083382::ResultType RA083382::solveFast(const double max_time) {
    cout << "\n--> Resolvendo mega rapido e magico algoritmo em "
         << max_time << " segundos."
         << endl;

    return RA083382::FAST_HEURISTIC_NO_SOLUTION;
}

//------------------------------[ chutaCiclo ]-------------------------------//

void RA083382::chutaCiclo() {
    // Primeiro, fazemos isso e aquilo usando tal ideia
    //...
    //...
    // Depois, pegamos tal coisa e invertemos usando um 2OPT, etc e tal...
    //...
    //...

    ze.roda();

    cout << "\n:-P" << endl;

    cout << "\nnodes: ";
    for(ListGraph::NodeIt v(graph); v != INVALID; ++v)
         cout << graph.id(v) << ": " << terminal[v] << " | ";

    cout << "\nedges: ";
    for(ListGraph::EdgeIt e(graph); e != INVALID; ++e)
         cout << "(" << graph.id(graph.u(e))
              << "," << graph.id(graph.v(e))
              << "): " << length[e]
              << " | ";

    cout << endl;
}
