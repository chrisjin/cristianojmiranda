/*******************************************************************************

 Implementação do componente aluno para gerenciar dados de alunos da Unicamp.

 <lab02.c>


 Grupo 4: Cristiano J. Miranda  RA: 083382
 Gustavo F. Tiengo     RA: 071091
 Magda A. Silva        RA: 082070
 12/04/2010


 *******************************************************************************/
/* insert.c...
 Contains insert() function to insert a key into a btree.
 Calls itself recursively until bottom of tree is reached.
 Then inserts key in node.
 If node is out of room,
 - calls split() to split node
 - promotes middle key and rrn of new node
 */
#include "btreealuno.h"
#include "stdio.h"
#include "fileio.h"
#include "unistd.h"
#include "bundle.h"
#include "utils.h"
#include "log.h"

// Ordem da b-tree
int btOrder = MAXKEYS;

// Nome do arquivo de index
char btreeIndexFileName[1024];

// Nome para o arquivo com as chaves duplicadas
char btreeDuplicateFileName[1024];

/* insert() ...
 Arguments:
 rrn:            rrn of page to make insertion in
 *promo_r_child: child promoted up from here to next level
 key:            key to be inserted here or lower
 *promo_key:     key promoted up from here to next level
 */
boolean insert(short rrn, TAlunoNode key, short *promo_r_child,
		TAlunoNode *promo_key) {

	debugi("RRN", rrn);
	debugc("Key", key.ra);
	if (promo_key != NULL) {
		debugi("Promo key", promo_key->ra);
	}
	debugi("Promo child", *promo_r_child);

	debug("Pagina corrente");
	BTPAGE page;

	debug("Pagina nova caso ocorra split");
	BTPAGE newpage;

	debug("Valores booleanos de controle");
	int found, promoted;

	debug("RRN do node promovido");
	short pos, p_b_rrn;

	debug("Chave do node promovido");
	TAlunoNode p_b_key;

	debug("Verifica se RRN eh null para fazer promocao");
	if (rrn == NIL) {
		debug("Promovendo");

		debug("Setando promo_key");
		*promo_key = key;
		*promo_r_child = NIL;

		debug("Retornando registro promovido");
		return true;
	}

	btread(rrn, &page);
	found = search_node(key.ra, &page, &pos);
	if (found) {
		printf("Error: attempt to insert duplicate key: %c \n\007", key);
		return (0);
	}
	promoted = insert(page.child[pos], key, &p_b_rrn, &p_b_key);
	if (!promoted)
		return false; /* no promotion */
	if (page.keycount < MAXKEYS) {
		ins_in_page(p_b_key, p_b_rrn, &page); /* OK to insert key and  */
		btwrite(rrn, &page); /* pointer in this page. */
		return false; /* no promotion */
	} else {
		split(p_b_key, p_b_rrn, &page, promo_key, promo_r_child, &newpage);
		btwrite(rrn, &page);
		btwrite(*promo_r_child, &newpage);
		return true; /* promotion */
	}
}

/* btio.c...
 Contains btree functions that directly involve file i/o:

 btopen() -- open file "btree.dat" to hold the btree.
 btclose() -- close "btree.dat"
 getroot() -- get rrn of root node from first two bytes of btree.dat
 putroot() -- put rrn of root node in first two bytes of btree.dat
 create_tree() -- create "btree.dat" and root node
 getpage() -- get next available block in "btree.dat" for a new page
 btread() -- read page number rrn from "btree.dat"
 btwrite() -- write page number rrn to "btree.dat"
 */

int btfd; /* global file descriptor for "btree.dat"  */

boolean btopen() {

	debug("Obtendo o nome do arquivo para indexar arvore de aluno");
	char *indexFileName = getProperty("btreealuno.index.file");
	debugs("Index file Name:", indexFileName);

	btfd = open(indexFileName, O_RDWR);
	return (btfd > 0);
}

btclose() {
	close(btfd);
}

short getroot() {
	short root;
	long lseek();

	lseek(btfd, 0L, 0);
	if (read(btfd, &root, 2) == 0) {
		error("Error: Unable to get root.\007\n");
	}
	return (root);
}

putroot(short root) {
	lseek(btfd, 0L, 0);
	write(btfd, &root, 2);
}

short create_tree(TAlunoNode key) {

	debug("Criando B-TREE");

	btfd = creat(getBTreeIndexFileName(), PMODE);

	debug("Fechando o arquivo de index");
	close(btfd);

	debug("Abrindo a B-TREE");
	btopen();

	return (create_root(key, NIL, NIL));
}

short getpage() {

	debug("Obtendo uma nova pagina");

	long lseek(), addr;
	addr = lseek(btfd, 0L, 2) - 2L;
	short rrn = ((short) addr / PAGESIZE);

	debugi("RRN da pagina", rrn);

	return rrn;
}

btread(short rrn, BTPAGE *page_ptr) {

	debug("Lendo pagina da B-TREE");
	debugi("RRN", rrn);
	long lseek(), addr;

	addr = (long) rrn * (long) PAGESIZE + 2L;
	lseek(btfd, addr, 0);
	ssize_t rst = (read(btfd, page_ptr, PAGESIZE));

	logPage(page_ptr);

	return rst;
}

btwrite(short rrn, BTPAGE *page_ptr) {
	long lseek(), addr;
	addr = (long) rrn * (long) PAGESIZE + 2L;
	lseek(btfd, addr, 0);
	return (write(btfd, page_ptr, PAGESIZE));
}

void logPage(BTPAGE *page) {

	if (page != NULL) {

		debugi("Quantidade de chaves", page->keycount);
		debugc("Chaves: ", page->key);

	} else {

		debug("Page NULL");

	}

}

/* btutil.c...
 Contains utility functions for btree program:

 create_root() -- get and initialize root node and insert one key
 pageinit() -- put NOKEY in all "key" slots and NIL in "child" slots
 search_node() -- return YES if key in node, else NO. In either case,
 put key's correct position in pos.
 ins_in_page() -- insert key and right child in page
 split() -- split node by creating new node and moving half of keys to
 new node. Promote middle key and rrn of new node.
 */

short create_root(TAlunoNode key, short left, short right) {

	debug("Criando a raiz da B-TREE");

	BTPAGE page;
	short rrn;

	rrn = getpage();
	pageinit(&page);
	page.key[0] = key;
	page.child[0] = left;
	page.child[1] = right;
	page.keycount = 1;
	btwrite(rrn, &page);
	putroot(rrn);

	debugi("Retornando RRN: ", rrn);
	return (rrn);
}

pageinit(BTPAGE *p_page) /* p_page: pointer to a page  */
{
	int j;

	for (j = 0; j < MAXKEYS; j++) {
		p_page->key[j].index = NIL;
		p_page->key[j].ra = NIL;
		p_page->child[j] = NIL;
	}
	p_page->child[MAXKEYS] = NIL;
}

/* pos: position where key is or should be inserted  */
boolean search_node(int key, BTPAGE *p_page, short *pos) {

	debugc("Key: ", key);

	debug("Posicionando o cursor onde a chave possa estar");
	int i;
	for (i = 0; i < p_page->keycount && key > p_page->key[i].ra; i++)
		;

	debugi("Position: ", i);
	*pos = i;

	if (*pos < p_page->keycount && key == p_page->key[*pos].ra) {
		debug("Node encontrado na pagina");
		return true;
	} else {
		debug("Node nao encontrado");
		return false;
	}
}

ins_in_page(TAlunoNode key, short r_child, BTPAGE *p_page) {
	int i;

	for (i = p_page->keycount; key.ra < p_page->key[i - 1].ra && i > 0; i--) {
		p_page->key[i] = p_page->key[i - 1];
		p_page->child[i + 1] = p_page->child[i];
	}
	p_page->keycount++;
	p_page->key[i] = key;
	p_page->child[i + 1] = r_child;
}

/* split ()
 Arguments:
 key:           key to be inserted
 promo_key:     key to be promoted up from here
 r_child:       child rrn to be inserted
 promo_r_child: rrn to be promoted up from here
 p_oldpage:     pointer to old page structure
 p_newpage:     pointer to new page structure
 */
split(TAlunoNode key, short r_child, BTPAGE *p_oldpage, TAlunoNode *promo_key,
		short *promo_r_child, BTPAGE *p_newpage) {
	int i;
	short mid; /* tells where split is to occur            */
	TAlunoNode workkeys[MAXKEYS + 1]; /* temporarily holds keys, before split     */
	short workch[MAXKEYS + 2]; /* temporarily holds children, before split */

	for (i = 0; i < MAXKEYS; i++) { /* move keys and children from  */
		workkeys[i] = p_oldpage->key[i]; /* old page into work arrays    */
		workch[i] = p_oldpage->child[i];
	}
	workch[i] = p_oldpage->child[i];
	for (i = MAXKEYS; key.ra < workkeys[i - 1].ra && i > 0; i--) { /* insert new key */
		workkeys[i] = workkeys[i - 1];
		workch[i + 1] = workch[i];
	}
	workkeys[i] = key;
	workch[i + 1] = r_child;

	*promo_r_child = getpage(); /* create new page for split,   */
	pageinit(p_newpage); /* and promote rrn of new page  */

	for (i = 0; i < MINKEYS; i++) { /* move first half of keys and  */
		p_oldpage->key[i] = workkeys[i]; /* children to old page, second */
		p_oldpage->child[i] = workch[i]; /*  half to new page            */
		p_newpage->key[i] = workkeys[i + 1 + MINKEYS];
		p_newpage->child[i] = workch[i + 1 + MINKEYS];
		p_oldpage->key[i + MINKEYS].ra = NIL; /* mark second half of old  */
		p_oldpage->key[i + MINKEYS].index = NIL; /* mark second half of old  */
		p_oldpage->child[i + 1 + MINKEYS] = NIL; /* page as empty            */
	}
	p_oldpage->child[MINKEYS] = workch[MINKEYS];
	p_newpage->child[MINKEYS] = workch[i + 1 + MINKEYS];
	p_newpage->keycount = MAXKEYS - MINKEYS;
	p_oldpage->keycount = MINKEYS;
	*promo_key = workkeys[MINKEYS]; /* promote middle key */
}

setBtreeIndexFileName(char fileName[1024]) {
	strcpy(btreeIndexFileName, fileName);
}

char *getBTreeIndexFileName() {

	debug("Verifica se foi fornecido um nome para o arquivo de index");

	if (isStrEmpty(btreeIndexFileName)) {
		debug("Obtendo o nome do arquivo para indexar arvore de aluno");
		char *indexFileName = getProperty("btreealuno.index.file");
		debugs("Index file Name:", indexFileName);

		return indexFileName;

	}

	return btreeIndexFileName;

}

setBtreeDuplicateFileName(char fileName[1024]) {
	strcpy(btreeDuplicateFileName, fileName);
}

char *getBTreeDuplicateFileName() {

	debug("Verifica se foi fornecido um nome para o arquivo de index");

	if (isStrEmpty(btreeDuplicateFileName)) {
		debug("Obtendo o nome do arquivo para indexar arvore de aluno");
		char *indexFileName = getProperty("btreealuno.duplicate.file");
		debugs("Index file Name:", indexFileName);

		return indexFileName;

	}

	return btreeIndexFileName;

}

void setOrderTree(int order) {
	btOrder = order;
}
