/*******************************************************************************

 Implementação do componente aluno para gerenciar dados de alunos da Unicamp.

 <lab02.c>


 Grupo 4: Cristiano J. Miranda  RA: 083382
 Gustavo F. Tiengo     RA: 071091
 Magda A. Silva        RA: 082070
 12/04/2010


 *******************************************************************************/

#define T 10
#define MAX_CHAVES (2 * T - 1) //Quantidade máxima de chaves
#define	MAX_FILHOS  (2 * T) //Quantidade máxima de filhos
#define	MIN_OCUP  (T - 1) //Ocupação mínima em cada nó
#define ARVORE_SIZE sizeof(arvoreB)
#define SIZE_OF_INDEX_ROOT sizeof(long)
#define NIL -1

/* Estrutura responsavel por armazenar os nodes da arvore (ra e index). */
typedef struct {

	int ra;
	long index;

} TAlunoNode;

typedef struct {
	long rrn;
	int num_chaves; //Quantidades de chaves contida no nó
	TAlunoNode aluno[MAX_CHAVES];
	long indexFilhos[MAX_FILHOS]; // Posicao no arquivo para os registros de filhos
} arvoreB;

/**
 * Insere uma nova informacao na arvore.
 * @param raiz  Raiz da arvore
 * @param info Informacao a ser inserida na arvore.
 * @param rrnRoot Apontador para retornar o rrn da raiz.
 * @return estrutura da raiz da arvore.
 */
arvoreB insere_arvoreB(arvoreB *raiz, TAlunoNode info, long *rrnRoot);

/**
 * Imprime uma pagina da arvore.
 *
 * @param node NO da arvore.
 */
void printPageT(arvoreB node);

/**
 * Cria uma estrutura da arvore.
 *
 * @param node Informacao inicial da arvore.
 * @param rrnRoot Apontador para o rrn da raiz da arvore.
 * @return estrututura para a raiz da arvore.
 *
 */
arvoreB criarArvore(TAlunoNode node, long *rrnRoot);

/**
 * Obtem um rrn para uma nova pagina.
 *
 * @return rrn.
 */
long obtemNewIndexPagina();

/**
 * Le uma pagina no arquivo da arvore apartir de um rrn.
 *
 * @param rrn do index da pagina.
 * @param page Apontador para salvar as informacoes da pagina.
 */
void lerPagina(long rrn, arvoreB *page);

/**
 * Fecha a arvore de dados.
 */
void fecharArvore();

/**
 * Abre a arvore de dados.
 *
 * @param new Indicador para recriar a arvore. Caso true deleta o arquivo de dados e cria um vazio.
 */
int abrirArvore(int new);

/**
 * Obtem o rrn referente a raiz da arvore no arquivo de dados.
 */
long obtemPosicaoRaiz();

/**
 * Obtem o nome do arquivo de dados.
 */
char *getBTreeIndexFileName();
