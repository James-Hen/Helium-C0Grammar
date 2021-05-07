/*
 *	Common.c: defines the shared data structure and function
 *	Author: James Zhang
 */

#include "Common.h"

int node_cnt = 0;
struct Node* root = NULL;

// newnode set this node (often leaves)
struct Node* newnode(const char* name) {
	struct Node* p = (struct Node*)malloc(sizeof(struct Node));
	p->name = strdup(name);
	p->id = node_cnt++;
	p->chcnt = 0;
	return p;
}
// setputn: set this node and childs
struct Node* setputn(const char* name, int chcnt, ...) {
	struct Node* p = newnode(name);
	p->chcnt = chcnt;
	p->ch = (struct Node**)malloc(chcnt * sizeof(struct Node*));
	va_list args;
	va_start(args, chcnt);
	for (int i = 0; i < chcnt; i++) {
		struct Node* chi = va_arg(args, struct Node*);
		p->ch[i] = chi;
    }
	va_end(args);
	return p;
}
// trav_delete: free spaces
void trav_delete(struct Node* rt) {
	for (int i = 0; i < rt->chcnt; ++i) {
		trav_delete(rt->ch[i]);
	}
	free(rt->name);
	free(rt);
}
// trav_outputf: as name indicated
void trav_outputf(FILE* f, struct Node* rt) {
	fprintf(f, "%d %s %d", rt->id, rt->name, rt->chcnt);
	for (int i = 0; i < rt->chcnt; ++i) {
		fprintf(f, " %d", rt->ch[i]->id);
	}
	fprintf(f, "\n");
	for (int i = 0; i < rt->chcnt; ++i) {
		trav_outputf(f, rt->ch[i]);
	}
}