/*******************************************************************************

 Atividade 3 - Biblioteca para manipulacao de listas

 Cristiano J. Miranda RA.: 083382 MC202 EF             05/09/08


 *******************************************************************************/

#include <stdio.h>
#include "mylist.h"

/*******************************************************
 criação de uma lista
 parâmetro: apontador p/ função que libera um valor
 associado a um elemento da lista.
 devolve o apontador para o descritor da lista.
 *******************************************************/
LIST newList() {
	setMethodName("newList");
	debug("Construindo uma lista nova");
	LIST result = (LIST) malloc(sizeof(list));
	result->count = 0;
	result->content = NULL;
	lastMethodName();
	return result;
}

/******************************************************
 insere um 'elemento' no início da lista
 parâmetros:
 - apontador p/ a lista
 - endereço do elemento a ser inserido
 devolve TRUE ou FALSE indicando sucesso ou falha
 da operação.
 ******************************************************/
int frontInsert(LIST list, void * object) {
	setMethodName("frontInsert");
	debug("inserindo um novo objeto na lista");
	if (list == NULL || object == NULL) {
		if (object == NULL)
			debug("objeto nulo");
		else
			debug("lista nulo");

		return FALSE;
	}

	debugs("object: ", object);

	nodeptr n = malloc(sizeof(node));
	n->value = object;

	nodeptr l = list->content;
	if (l == NULL) {
		debug("inserindo o primeiro elemento da lista");
		n->prev = n;
		n->next = n;
		list->content = n;
	}

	else {
		debug("inserindo outro elemento na lista");
		n->prev = l->prev;
		n->next = l;
		list->content = n;
	}

	list->count++;
	debugi("tamanho da lista", list->count);

	lastMethodName();
	return TRUE;
}

/******************************************************
 insere um 'elemento' no final da lista
 parâmetros:
 - apontador p/ a lista
 - endereço do elemento a ser inserido
 devolve TRUE ou FALSE indicando sucesso ou falha
 da operação.
 ******************************************************/
int rearInsert(LIST list, void * object) {
	setMethodName("rearInsert");
	debug("inserindo um novo elemento na lista");
	if (list == NULL || object == NULL) {
		if (object == NULL)
			debug("objeto nulo");
		else
			debug("lista nulo");

		return FALSE;
	}

	debug("Alocando um novo elemento na lista");
	nodeptr n = malloc(sizeof(node));
	n->value = object;

	debug("Obtendo o primeiro elemento da lista");
	nodeptr l = list->content;
	if (l == NULL) {
		debug("Lista vazia. Inserindo o primeiro elemento na lista");
		n->prev = n;
		n->next = n;
		list->content = n;
	}

	else {
		debug("Lista nao vazia. Inserindo outro elemento na lista");

		if (l->next == l) {
			debug("Lista contem somente um elemento");
			l->next = n;
			l->prev = n;
			n->prev = l;
			n->next = l;
		}

		else {
			debug("Lista contem varios elementos");
			nodeptr ult = l->prev;
			ult->next = n;
			n->prev = ult;
			n->next = l;
			l->prev = n;

			debugs("Ultimo elemento da lista: ", ult->value);
			debugs("Primeiro elemento da lista: ", l->value);
		}
	}

	list->count++;
	debugi("tamanho da lista", list->count);

	lastMethodName();
	return TRUE;
}

/*******************************************************
 remove o primeiro elemento de uma lista
 parâmetro: apontador para a lista
 devolve o apontador para o elemento retirado da lista
 ********************************************************/
void* removeFirst(LIST list) {
	setMethodName("removeFirst");
	debug("removendo o primeiro elemento da lista");
	if (list == NULL) {
		debug("lista nula");
		return NULL;
	}

	nodeptr n = list->content;
	if (n == NULL) {
		debug("lista vazia");
		return NULL;
	}

	list->content = n->next;
	list->count--;
	n->prev = NULL;
	n->next = NULL;
	debugi("tamanho da lista", list->count);

	debugs("objeto: ", n->value);

	lastMethodName();
	return n->value;
}

/*******************************************************
 remove o último elemento de uma lista
 parâmetro: apontador para o descritor da lista
 devolve o apontador para o elemento retirado da lista
 *******************************************************/
void* removeLast(LIST list) {
	setMethodName("removeLast");
	debug("removendo o ultimo item da lista");

	if (list == NULL)
		return NULL;

	nodeptr n = list->content;
	if (n == NULL)
		return NULL;

	nodeptr l = n->prev;
	if (l == n)
		return NULL;

	list->count--;
	n->prev = NULL;
	n->next = NULL;

	return l->value;
}

/******************************************************
 devolve um elemento da lista pela sua posição
 parâmetros:
 - apontador para o descritor da lista
 - posição do elemento a ser devolvido(a partir de 0)
 devolve o apontador para o elemento (ou NULL se não existir).
 ******************************************************/
void * getElement(LIST list, int index) {
	setMethodName("getElement");
	debugi("obtendo elemento na posicao: ", index);
	debugi("tamanho da lista: ", list->count);

	if (list == NULL || index < 0) {
		debug("lista vazia");
		return NULL;
	}

	if (list->count < index) {
		debug("index invalido em relacao ao tamanho da lista");
		return NULL;
	}

	int i = 0;
	nodeptr n = list->content;
	while (n != NULL) {
		debug("procurando elemento na lista...");
		if (i == index) {
			debugs("objeto: ", n->value);
			return n->value;
		}

		n = n->next;
		i++;
	}

	debug("retornando o primeiro objeto da lista");
	if (n == NULL)
		return n;

	debugs("objeto: ", n->value);
	return n->value;
}

/*****************************************************
 libera todo o conteúdo de uma uma lista
 (não libera o descritor)
 parâmetro: apontador para o descritor da lista.
 ****************************************************/
int freeList(LIST list, void(*freeNode)(void*)) {
	setMethodName("freeList");
	debugi("tamanho da lista", list->count);
	debug("liberando a lista");
	if (list == NULL) {
		debug("lista nula");
		return FALSE;
	}

	nodeptr n = list->content;
	if (n != NULL) {
		debug("deletando item a item...");
		list->content = NULL;

		int i;
		nodeptr l = n;
		for (i = 1; i < list->count; i++) {
			n = n->next;
			debugs("valor a ser deletado: ", n->value);
			free(n);
			debug("deletando ...");
		}

		debugs("valor a ser deletado: ", l->value);
		free(l);

		list->count = 0;
	}

	return TRUE;
}

/*********************************************************
 devolve o tamanho de uma lista (número de elementos)
 parâmetro: apontador para o descritor da lista.
 *********************************************************/
int listSize(LIST list) {
	setMethodName("listSize");
	if (list == NULL) {
		debug("lista vazia");
		return 0;
	}

	else {
		debugi("tamanho da lista: ", list->count);
		return list->count;
	}
}
