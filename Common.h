/*
 *	Common.c: declares the shared data structure and function
 *	Author: James Zhang
 */

#ifndef COMMON_H
#define COMMON_H

#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <malloc.h>

struct Node {
	int id, chcnt;
	char* name;			// string, shall use strdup()/free() to point to a heap space
	struct Node** ch;
};
struct Node* newnode(const char* name);
struct Node* setputn(const char* name, int chcnt, ...);
void trav_delete(struct Node* rt);
void trav_outputf(FILE* f, struct Node* rt);

#endif