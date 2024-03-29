/******************************************************************************
 * main.cpp: call optimization algorithms.
 *
 * Author: Carlos Eduardo de Andrade <andrade@ic.unicamp.br>
 *
 * (c) Copyright 2011 Institute of Computing, University of Campinas.
 *     All Rights Reserved.
 *
 *  Created on : Oct 01, 2011 by andrade
 *  Last update: Oct 03, 2011 by andrade
 *
 * This software is licensed under the Common Public License. Please see
 * accompanying file for terms.
 *****************************************************************************/

#include <iostream>
#include <iomanip>
#include <list>
using namespace std;

#include <lemon/list_graph.h>
using namespace lemon;

#include "timer.hpp"
#include "mtrand.hpp"
#include "RA083382/RA083382.hpp"

//-------------------------------[ Main ]------------------------------------//

int main(int argc, char* argv[]) {
    SteinerCycleSolver* solver = new RA083382();
    Timer timer;

    //---------------------- Carrega uma instancia ----------------------//

    if(!solver->loadInstance(argv[1]))
        return -1;

    solver->displayInstance();

    //------------------- Checa se podemos ter ciclos -------------------//

    if(solver->haveTerminalLeaves())
        cout << "\n\n--->> A instancia " << argv[1]
             << " nao tem solucao!!" << endl;
    else
        cout << "\n\n--->> A instancia " << argv[1]
             << " pode ter solucao!!" << endl;

    //---------------------- Exemplo de otimiza��o ----------------------//

    timer.restart();
    solver->solve(12.4);
    cout << "No solve(), gastei " << timer.elapsed() << endl;

    timer.restart();
    solver->solveFast(31);
    cout << "No solveFast(), gastei " << timer.elapsed() << endl;

    //------------------------ Outras chamadas -------------------------//

    cout << "\nLB & UB & Solution Value & Time(s)\n"
         << solver->lb << " & "
         << solver->ub << " & ";

    dynamic_cast<RA083382*>(solver)->chutaCiclo();

    //------------------ Testando a uma solu��o --------------------//

    switch(solver->checkSolution(solver->best_solution, 500.0)) {
    case SteinerCycleSolver::INCORRECT_CYCLE:
        cout << "\n\n++ Ciclo incorreto" << endl;
        break;

    case SteinerCycleSolver::INCORRECT_VALUE:
        cout << "\n\n++ valor do ciclo incorreto" << endl;
        break;

    case SteinerCycleSolver::MISSING_TERMINALS:
        cout << "\n\n++ Ciclo nao cobriu todos terminais" << endl;
        break;

    default:
        cout << "\n\n++ solucao correta" << endl;
    }

    //--------------------- Exemplo do Mersenne Twister ---------------------//

    // Gerador de n�meros aleat�rios com uma seed qualquer
    MTRand rng(1453264);

    cout << "\n\n Imprimindo alguns numero aleatorios: "
         << rng.randInt() << " "
         << rng.randInt() << " "
         << rng.rand() << " "
         << rng.rand();

    //--------------------- Exemplo de sa�da ---------------------//
    solver->displaySolution(solver->best_solution);

    char result = 'Y';

    // Formata a saida e imprime os resultados
    cout << setiosflags(ios::fixed) << setprecision(2)
         << "\nSolution & Time & Best Solution Value\n"
         << result << " & "
         << timer.elapsed() << " & "
         << (result != 'N'? solver->solution_value : 0.00);

    // N�O PULE LINHA NO FINAL E N�O USE ENDL. USE FLUSH() AO INVES.
    cout.flush();

    delete solver;
    return 0;
}
