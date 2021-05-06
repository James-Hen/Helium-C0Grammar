/*
 *	Common.c: declares the shared data structure and function
 *	Author: James Zhang
 */

#ifndef COMMON_H
#define COMMON_H

#include <stdio.h>
#include <stdarg.h>
#include <malloc.h>

struct Node {
	int id, chcnt;
	const char* name;
	struct Node** ch;
};
void setputn(struct Node* &n, const char* name, int chcnt, ...);
struct Node* newnode(const char* name);

#endif