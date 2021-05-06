#include <stdio.h>
#include <string.h>

#define MAX_WORD_LEN 500

char wordbuf[MAX_WORD_LEN], prebuf[MAX_WORD_LEN], head[MAX_WORD_LEN];

void fprint_indent(FILE* f, const char* kw) {
	for (int i = 0; i < 3 - (strlen(kw)+2) / 4; i++)
		fprintf(f, "\t");
}

int main() {
    FILE* inpf = fopen("DevUtils/sem.txt", "w+"), * outf = fopen("DevUtils/c0grammer.txt", "w+");
    // understand it as a simple DFA model and look forward stream
    int sym_count = 0;
    while (~fscanf(inpf, "%s", prebuf)) {
        if (!strcmp(prebuf, ":")) {
            strcpy(head, wordbuf);
            fprintf(outf, "%s", head);
            fprint_indent(outf, head);
            fprintf(outf, ":\t");
            continue;
        }
        if (!strcmp(prebuf, "|")) {
            sym_count = 0;
            /// todo
            fprintf(outf, "\t\t\t|\t");
            continue;
        }
        if (!strcmp(prebuf, ";")) {
            sym_count = 0;
            fprintf(outf, "\t\t\t;\n");
            continue;
        }
        strcpy(wordbuf, prebuf);
    }
    return 0;
}