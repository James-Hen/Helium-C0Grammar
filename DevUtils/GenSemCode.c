#include <stdio.h>
#include <string.h>

#define MAX_WORD_LEN 500

char wordbuf[MAX_WORD_LEN], prebuf[MAX_WORD_LEN], head[MAX_WORD_LEN];

void fprint_indent(FILE* f, const char* kw) {
	for (int i = 0; i < 3 - strlen(kw) / 4; i++)
		fprintf(f, "\t");
}
void fprintsemantic(FILE* f, const char* h, int ch) {
	fprintf(f, "\t\t\t\t{ $$ = setputn(\"%s\", %d", head, ch);
    for (int i = 1; i <= ch; ++i) {
	    fprintf(f, ", $%d", i);
    }
    fprintf(f, "); }");
}

int main() {
    FILE* inpf = fopen("DevUtils/c0grammar.txt", "r"), * outf = fopen("DevUtils/sem.txt", "w+");
    if (inpf == NULL || outf == NULL) {
        printf("ERROR: Cannot open file\n");
    }
    // understand it as a simple DFA model and look forward stream
    int sym_count = 0;
    while (~fscanf(inpf, "%s", prebuf)) {
        if (!strcmp(prebuf, ":")) {
            sym_count = 0;
            strcpy(head, wordbuf);
            fprint_indent(outf, head);
            fprintf(outf, ":\t");
            continue;
        }
        if (!strcmp(prebuf, "|") || !strcmp(prebuf, ";")) {
            if (!strcmp(wordbuf, "%empty")) {
                sym_count = 0;
            }
            fprintf(outf, "\n");
            fprintsemantic(outf, head, sym_count);
            fprintf(outf, "\n");
            sym_count = 0;
            if (!strcmp(prebuf, "|")) {
                fprintf(outf, "\t\t\t|\t");
                continue;
            }
            if (!strcmp(prebuf, ";")) {
                fprintf(outf, "\t\t\t;\n");
                continue;
            }
        }
        strcpy(wordbuf, prebuf);
        if (sym_count++) 
            fprintf(outf, " ");
        fprintf(outf, "%s", wordbuf);
    }
    fclose(inpf);
    fclose(outf);
    return 0;
}