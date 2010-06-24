#include <stdio.h>
#include "stdio.h"
#include "stdio.h"
#include "unistd.h"
#include "log.h"
#include "utils.h"
#include "btreealuno.h"

#include <fcntl.h>

char btreeIndexFileName[1024];
char btreeDuplicateFileName[1024];
int btOrder;
FILE *btFile = NULL;

printArvore(arvoreB raiz) {

	debug("Imprimido a arvore");

	printf("{\n");

	printPageT(raiz);

	printf("\n}");

}

void printPageT(arvoreB node) {

	printf("(");

	int i = 0;
	int isChave = 0;
	int chaveIndex = 0, filhosIndex = 0;
	for (i = 0; i < (MAX_CHAVES + MAX_FILHOS); i++) {
		if (isChave) {
			printf("[%i,%i],", node.aluno[chaveIndex].ra,
					node.aluno[chaveIndex].index);
			chaveIndex++;
		} else {
			if (node.indexFilhos[filhosIndex] >= 0) {

				arvoreB child;
				lerPagina(node.indexFilhos[filhosIndex], &child);

				printPageT(child);

			}
			filhosIndex++;
		}
		isChave = !isChave;
	}

	printf(")\n");

}

//Insere uma chave e o ponteiro para o filho da direita em um nó
//void insere_chave(arvoreB *raiz, TAlunoNode info, arvoreB *filhodir) {
void insere_chave(arvoreB *raiz, TAlunoNode info, long filhodir) {
	int k, pos;

	debugl("filhodir:", filhodir);

	//busca para obter a posição ideal para inserir a nova chave
	pos = busca_binaria(raiz, info);
	k = raiz->num_chaves;

	//realiza o remanejamento para manter as chaves ordenadas
	while (k > pos && info.ra < raiz->aluno[k - 1].ra) {
		raiz->aluno[k] = raiz->aluno[k - 1];
		//raiz->filhos[k + 1] = raiz->filhos[k];
		raiz->indexFilhos[k + 1] = raiz->indexFilhos[k];
		k--;
	}
	//insere a chave na posição ideal
	raiz->aluno[pos] = info;
	//raiz->filhos[pos + 1] = filhodir;
	raiz->indexFilhos[pos + 1] = filhodir;
	raiz->num_chaves++;

	if (raiz->rrn >= 0 && raiz->num_chaves <= MAX_CHAVES) {
		escreverPagina(raiz->rrn, raiz);
	}
}

//Realiza a busca do nó para inserir a chave e faz as subdivisões quando necessárias
arvoreB *insere(arvoreB *raiz, TAlunoNode info, int *h,
		TAlunoNode *info_retorno) {
	int i, j, pos;
	TAlunoNode info_mediano; //auxiliar para armazenar a chave que irá subir para o pai
	arvoreB *temp = NULL, *filho_dir = NULL; //ponteiro para o filho à direita da chave

	if (raiz == NULL || raiz->num_chaves > MAX_CHAVES || raiz->num_chaves < 0
			|| raiz->rrn < 0) {
		//O nó anterior é o ideal para inserir a nova chave (chegou em um nó folha)
		*h = 1;
		*info_retorno = info;
		return (NULL);
	} else {
		pos = busca_binaria(raiz, info);
		if (raiz->num_chaves > pos && raiz->aluno[pos].ra == info.ra) {
			printf("Chave já contida na Árvore");
			*h = 0;
		} else {
			//desce na árvore até encontrar o nó folha para inserir a chave.
			long rrnFilho = raiz->indexFilhos[pos];
			if (rrnFilho == NIL) {

				*h = 1;
				*info_retorno = info;
				filho_dir = NULL;

			} else {
				arvoreB filho;
				lerPagina(rrnFilho, &filho);
				filho_dir = insere(&filho, info, h, info_retorno);
			}
			if (*h) //Se true deve inserir a info_retorno no nó.
			{
				if (raiz->num_chaves < MAX_CHAVES) //Tem espaço na página
				{
					if (filho_dir == NULL) {
						insere_chave(raiz, *info_retorno, NIL);
					} else {
						insere_chave(raiz, *info_retorno, filho_dir->rrn);
					}

					*h = 0;
				} else { //Overflow. Precisa subdividir

					temp = (arvoreB *) malloc(sizeof(arvoreB));
					inicializaPagina(temp);

					//elemento mediano que vai subir para o pai
					info_mediano = raiz->aluno[MIN_OCUP];

					//insere metade do nó raiz no temp (efetua subdivisão)
					//temp->filhos[0] = raiz->filhos[MIN_OCUP + 1];
					temp->indexFilhos[0] = raiz->indexFilhos[MIN_OCUP + 1];
					for (i = MIN_OCUP + 1; i < MAX_CHAVES; i++) {
						//insere_chave(temp, raiz->aluno[i], raiz->filhos[i + 1]);
						insere_chave(temp, raiz->aluno[i], raiz->indexFilhos[i
								+ 1]);
					}

					long rrnFilhoDir = obtemNewIndexPagina();
					temp->rrn = rrnFilhoDir;
					escreverPagina(rrnFilhoDir, temp);

					//atualiza nó raiz.
					for (i = MIN_OCUP; i < MAX_CHAVES; i++) {
						raiz->aluno[i].ra = NIL;
						raiz->aluno[i].index = NIL;
						//raiz->filhos[i + 1] = NULL;
						raiz->indexFilhos[i + 1] = NIL;
					}
					raiz->num_chaves = MIN_OCUP;
					escreverPagina(raiz->rrn, raiz);

					long rrn = NIL;
					if (filho_dir != NULL && filho_dir->num_chaves
							<= MAX_CHAVES) {
						filho_dir->rrn = obtemNewIndexPagina();
						escreverPagina(filho_dir->rrn, filho_dir);
						rrn = filho_dir->rrn;
					}

					//Verifica em qual nó será inserida a nova chave
					if (pos <= MIN_OCUP) {
						insere_chave(raiz, *info_retorno, rrn);
					} else {
						insere_chave(temp, *info_retorno, rrn);
					}

					//retorna o mediano para inserí-lo no nó pai e o temp como filho direito do mediano.
					*info_retorno = info_mediano;

					escreverPagina(rrnFilhoDir, temp);

					return (temp);
				}
			}
		}
	}
}

arvoreB insere_arvoreB(arvoreB *raiz, TAlunoNode info, long *rrnRoot) {
	int h;
	int i;
	arvoreB *filho_dir, *nova_raiz;
	TAlunoNode info_retorno;

	filho_dir = insere(raiz, info, &h, &info_retorno);
	escreverPagina(raiz->rrn, raiz);

	if (h) { //Aumetará a altura da árvore

		nova_raiz = (arvoreB *) malloc(sizeof(arvoreB));

		inicializaPagina(nova_raiz);

		nova_raiz->num_chaves = 1;
		nova_raiz->aluno[0] = info_retorno;
		//nova_raiz->filhos[0] = raiz;
		//nova_raiz->filhos[1] = filho_dir;

		nova_raiz->indexFilhos[0] = *rrnRoot;
		nova_raiz->indexFilhos[1] = filho_dir->rrn;

		//for (i = 2; i <= MAX_CHAVES; i++)
		//	nova_raiz->filhos[i] = NULL;

		long rrn = obtemNewIndexPagina();
		nova_raiz->rrn = rrn;
		escreverPagina(rrn, nova_raiz);
		salvaPosicaoRaiz(rrn);
		*rrnRoot = rrn;

		return (*nova_raiz);
	} else {

		return (*raiz);

	}
}

int busca_binaria(arvoreB *no, int info) {
	int meio, i, f;

	i = 0;
	f = no->num_chaves - 1;

	while (i <= f) {
		meio = (i + f) / 2;
		if (no->aluno[meio].ra == info)
			return (meio); //Encontrou. Retorna a posíção em que a chave está.
		else if (no->aluno[meio].ra > info)
			f = meio - 1;
		else
			i = meio + 1;
	}
	return (i); //Não encontrou. Retorna a posição do ponteiro para o filho.
}

int busca(arvoreB *raiz, int info) {
	arvoreB *no;
	int pos; //posição retornada pelo busca binária.

	no = raiz;
	while (no != NULL) {
		pos = busca_binaria(no, info);
		if (pos < no->num_chaves && no->aluno[pos].ra == info) {
			return 1;
		} else {
			//no = no->filhos[pos];
			long rrn = no->indexFilhos[pos];
			lerPagina(rrn, no);
		}
	}
	return 0;
}

/**
 * Obtem a posicao da raiz no arquivo.
 */
long obtemPosicaoRaiz() {

	long root = NIL;

	fseek(btFile, 0, SEEK_SET);

	if (fread(&root, SIZE_OF_INDEX_ROOT, 1, btFile) != 1) {
		error("Error: Unable to get root.\007\n");
	}
	return (root);
}

/**
 * Salva a posicao da raiz.
 */
void salvaPosicaoRaiz(int root) {
	fseek(btFile, 0, SEEK_SET);
	fwrite(&root, SIZE_OF_INDEX_ROOT, 1, btFile);
	fflush(btFile);
}

int abrirArvore(int new) {

	if (new) {
		btFile = Fopen(getBTreeIndexFileName(), WRITE_FLAG);
		fclose(btFile);
		btFile = Fopen(getBTreeIndexFileName(), "r+b");

		return false;

	} else {

		if (fileExists(getBTreeIndexFileName())) {
			btFile = Fopen(getBTreeIndexFileName(), "r+b");
			return true;
		}

		btFile = Fopen(getBTreeIndexFileName(), "r+b");
		return false;
	}

	return true;
}

void fecharArvore() {
	fflush(btFile);
	fclose(btFile);
}

/**
 * Cria uma arvore binaria.
 */
arvoreB criarArvore(TAlunoNode node, long *rrnRoot) {

	// debug("Abre o arquivo para a arvore");
	abrirArvore(1);

	// debug("Aloca a arvore");
	arvoreB tree;

	// debug("Inicializa a raiz da arvore");
	inicializaPagina(&tree);

	// debug("Seta a raiz da arvore");
	tree.aluno[0] = node;
	tree.num_chaves++;

	long rrn = obtemNewIndexPagina();
	tree.rrn = rrn;
	escreverPagina(rrn, &tree);
	salvaPosicaoRaiz(rrn);

	*rrnRoot = rrn;

	return tree;

}

long obtemNewIndexPagina() {

	//debug("Obtendo uma nova pagina");

	fseek(btFile, 0, SEEK_END);
	long addr = ftell(btFile);
	addr = addr - SIZE_OF_INDEX_ROOT;

	// debugl("Addr", addr);

	if (addr < 0) {
		addr = 0;
	}

	long rrn = ((long) addr / ARVORE_SIZE);

	//debugi("RRN da pagina", rrn);


	return rrn;
}

void escreverPagina(long rrn, arvoreB *page) {

	debugl("rrn:", rrn);

	long addr = (long) (rrn * (long) ARVORE_SIZE) + SIZE_OF_INDEX_ROOT;
	fseek(btFile, addr, SEEK_SET);

	if (fwrite(page, ARVORE_SIZE, 1, btFile) != 1) {
		error("Erro ao gravar o registro no arquivo de dados");
	}
	fflush(btFile);
}

void lerPagina(long rrn, arvoreB *page) {

	debugl("rrn: ", rrn);

	if (rrn < 0) {
		page = NULL;
		return;
	}

	debug("Lendo pagina da B-TREE");
	long addr = (long) (rrn * (long) ARVORE_SIZE) + SIZE_OF_INDEX_ROOT;
	fseek(btFile, addr, SEEK_SET);

	if (fread(page, ARVORE_SIZE, 1, btFile) != 1) {
		error("Erro ao ler registro.");
	}

}

void inicializaPagina(arvoreB *page) {

	int i;

	page->num_chaves = 0;
	page->rrn = NIL;

	for (i = 0; i < MAX_CHAVES; i++) {
		page->aluno[i].index = NIL;
		page->aluno[i].ra = NIL;
	}

	for (i = 0; i < MAX_FILHOS; i++) {
		page->indexFilhos[i] = NIL;
	}
}

/**
 * Seta o nome do arquivo de dados.
 */
void setBtreeIndexFileName(char *fileName) {
	strcpy(btreeIndexFileName, fileName);
}

/**
 * Obtem o nome do arquivo de dados.
 */
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

/**
 * Seta o nome do arquivo de registros duplicados.
 */
void setBTreeDuplicateFileName(char *fileName) {
	strcpy(btreeDuplicateFileName, fileName);
}

/**
 * Obtem o nome do arquivo de registros duplicados.
 */
char *getBTreeDuplicateFileName() {

	debug("Verifica se foi fornecido um nome para o arquivo de index");

	if (isStrEmpty(btreeDuplicateFileName)) {
		debug("Obtendo o nome do arquivo para indexar arvore de aluno");
		char *indexFileName = getProperty("btreealuno.duplicate.file");
		debugs("Index file Name:", indexFileName);

		return indexFileName;

	}

	return btreeDuplicateFileName;

}

/**
 * Seta a ordem da arvore.
 */
void setOrderTree(int order) {
	btOrder = order;
}
