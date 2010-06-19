/*******************************************************************************

 Implementação do componente aluno para gerenciar dados de alunos da Unicamp.

 <lab02.c>


 Grupo 4: Cristiano J. Miranda  RA: 083382
 Gustavo F. Tiengo     RA: 071091
 Magda A. Silva        RA: 082070
 12/04/2010


 *******************************************************************************/

#define  MAXKEYS  10
#define  MINKEYS  MAXKEYS/2
#define  NIL      (-1)

extern short root; /* rrn of root page */
extern int btfd; /* file descriptor of btree file */
extern int infd; /* file descriptor of input file */

/* Estrutura responsavel por armazenar os nodes da arvore (ra e index). */
typedef struct {

	int ra;
	long index;

} TAlunoNode;

typedef struct {
	short keycount; /* number of keys in page	*/
	TAlunoNode key[MAXKEYS];
	short child[MAXKEYS + 1]; /* ptrs to rrns of descendants  */
} BTPAGE;

#define PAGESIZE  sizeof(BTPAGE)

void btclose();
int btopen();
void btread(short rrn, BTPAGE *page_ptr);
void btwrite(short rrn, BTPAGE *page_ptr);
short create_root(TAlunoNode key, short left, short right);
short create_tree(TAlunoNode key);
short getpage();
short getroot();

/**
 * Insere um aluno na B-TREE.
 *
 * @param rrn - Id da pagina onde o registro sera inserido.
 * @param key - Chave a ser inserida
 * @param recordString - Registro na forma de String para tratar duplicidade.
 * @param promo_r_child - Id do registro a ser promovido.
 * @param promo_key - Chave a ser promovida acima.
 * @return True caso haja promoção.
 */
int insertAlunoBTree(short rrn, TAlunoNode key, char *recordString,
		short *promo_r_child, TAlunoNode *promo_key);

void ins_in_page(TAlunoNode key, short r_child, BTPAGE *p_page);
void pageinit(BTPAGE *p_page);
void putroot(short root);
int search_node(int key, BTPAGE *p_page, short *pos);
void split(TAlunoNode key, short r_child, BTPAGE *p_oldpage,
		TAlunoNode *promo_key, short *promo_r_child, BTPAGE *p_newpage);

void setBtreeIndexFileName(char *fileName);

char *getBTreeIndexFileName();

char *getBTreeDuplicateFileName();

void setBTreeDuplicateFileName(char *fileName);

void setOrderTree(int order);
