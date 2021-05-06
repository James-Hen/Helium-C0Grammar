/*
 *	Common.c: defines the shared data structure and function
 *	Author: James Zhang
 */

#include "Common.h"

int node_cnt = 0;
struct Node* root;

// newnode set this node (often leaves)
struct Node* newnode(const char* name) {
	struct Node* p = (struct Node*)malloc(sizeof(struct Node));
	p->name = name;
	p->id = node_cnt;
	p->chcnt = 0;
	return p;
}
// setputn: set this node and output, and output it's child nodes
FILE* tree_out_f;
void setputn(struct Node* &n, const char* name, int chcnt, ...) {
	n = newnode(name);
    fprintf(tree_out_f, "%d %s", n->id, name);
	n->chcnt = chcnt;
	n->ch = (struct Node**)malloc(sizeof(struct Node*) * chcnt);
	va_list args;
	va_start(args, chcnt);
	for (int i = 0; i < chcnt; i++) {
       fprintf(tree_out_f, " %d", va_arg(args, struct Node*)->id);
		n->ch[i] = va_arg(args, struct Node*);
    }
	va_end(args);
	fprintf(tree_out_f, "\n");
}