/*******************************************************************************

 Implementação do componente aluno para gerenciar dados de alunos da Unicamp.

 <lab02.c>

 
 Grupo 4: Cristiano J. Miranda  RA: 083382
 Gustavo F. Tiengo     RA: 071091
 Magda A. Silva        RA: 082070
 12/04/2010


 *******************************************************************************/
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>

#define SEXO(a) (a == 'M' ? getMessage("aluno.label.sexo.masculino") : getMessage("aluno.label.sexo.feminino"))
#define INDEX_NOT_FOUND_FOR_ALUNO -1

/**Struct para guardar os dados do aluno */
typedef struct Aluno {
	int ra;
	char *nome;
	char *cidade;
	char *telContato;
	char *telAlternativo;
	char sexo;
	int curso;
} Aluno;

/**
 * Obtem os dados de um aluno pelo RA.
 *
 */
Aluno findAlunoByRa(int ra, FILE *file);

/**
 * Exibe os dados de um aluno.
 *
 */
void showAluno(Aluno aluno);
