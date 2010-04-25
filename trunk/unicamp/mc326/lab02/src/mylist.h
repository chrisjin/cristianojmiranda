/****** lists.h *******/
#define TRUE 1
#define FALSE 0

/* tipo 'apontador para lista */
typedef struct list* listptr;
typedef struct node* nodeptr;

typedef struct node {

	void* value;
	nodeptr prev, next;

} node;

typedef struct list {
	int count;
	nodeptr* content;
} list;

#define LIST listptr

/*******************************************************
 cria��o de uma lista
 par�metro: apontador p/ fun��o que libera um valor
 associado a um elemento da lista.
 devolve o apontador para o descritor da lista.
 *******************************************************/
LIST newList();

/******************************************************
 insere um 'elemento' no in�cio da lista
 par�metros:
 - apontador p/ a lista
 - endere�o do elemento a ser inserido
 devolve TRUE ou FALSE indicando sucesso ou falha
 da opera��o.
 ******************************************************/
int frontInsert( LIST, void *);

/******************************************************
 insere um 'elemento' no final da lista
 par�metros:
 - apontador p/ a lista
 - endere�o do elemento a ser inserido
 devolve TRUE ou FALSE indicando sucesso ou falha
 da opera��o.
 ******************************************************/
int rearInsert( LIST, void *);

/*******************************************************
 remove o primeiro elemento de uma lista
 par�metro: apontador para a lista
 devolve o apontador para o elemento retirado da lista
 ********************************************************/
void* removeFirst( LIST);

/*******************************************************
 remove o �ltimo elemento de uma lista
 par�metro: apontador para o descritor da lista
 devolve o apontador para o elemento retirado da lista
 *******************************************************/
void* removeLast( LIST);

/******************************************************
 devolve um elemento da lista pela sua posi��o
 par�metros:
 - apontador para o descritor da lista
 - posi��o do elemento a ser devolvido(a partir de 0)
 devolve o apontador para o elemento (ou NULL se n�o existir).
 ******************************************************/
void * getElement( LIST, int);

/*****************************************************
 libera todo o conte�do de uma uma lista
 (n�o libera o descritor)
 par�metro: apontador para o descritor da lista.
 ****************************************************/
int freeList( LIST, void(*freeNode)(void*));

/*********************************************************
 devolve o tamanho de uma lista (n�mero de elementos)
 par�metro: apontador para o descritor da lista.
 *********************************************************/
int listSize( LIST);
