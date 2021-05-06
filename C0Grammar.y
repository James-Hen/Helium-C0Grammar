/*
 *	C0Grammer.y: bison/yayacc input file, which describes C0 but not well implemented
 *	Author: James Zhang
 */

// ------------------Define Section------------------
%{

#include "Common.h"

extern "C" {
	void yyerror(const char *s);
	int yylex(void);
	
	extern struct Node* root;
}

%}

%union {
	struct Node* node;
}

%token<node> IDENTIFIER
// keywords in C0 (not fully supported)
%token<node> _INT _BOOL _STRING _CHAR _VOID _STRUCT _TYPEDEF _IF _ELSE _WHILE _FOR _CONTINUE _BREAK _RETURN _ASSERT _ERROR _TRUE _FALSE _NULL _ALLOC _ALLOC_ARRAY
// two-letter operators
%token<node> PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token<node> AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token<node> SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token<node> XOR_ASSIGN OR_ASSIGN
// literal operators
%token<node> ';' '{' '}' ',' ':' '=' '(' ')' '[' ']' '.' '&' '!' '~' '-' '+' '*' '/' '%' '<' '>' '^' '|' '?' 
// operator precedence
%right '=' MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%left OR_OP
%left AND_OP
%left '|'
%left '^'
%left '&'
%left EQ_OP NE_OP
%left '<' LE_OP GE_OP '>'
%left RIGHT_OP LEFT_OP
%left '+' '-'
%left '*' '/' '%'
%right '!' '~' INC_OP DEC_OP
%left '.'

// literals
%token<node> INTEGER
%token<node> FLOAT
%token<node> CHAR_LITERAL
%token<node> STRING_LITERAL
%token<node> LIB_LITERAL

// non-terminals
%type<node> root prog

%type<node> cdecl		// declaration
%type<node> args rght_args

%type<node> cdefn		// defination
%type<node> field_defn decl_assign body
%type<node> type

%type<node> stmts stmt else_stmt simple null_simple expr null_expr
%type<node> lftval

%type<node> params rght_params
%type<node> bin_op un_op asn_op
%type<node> number


// ------------------Rule Section------------------
// gengerate indexing semantic behavior by GenSemCode.py (except root!)
%%

root		:	prog
				{ setputn($$, "ROOT", 1, $1); root = $$; }
			;

// ------------------Subroutine Section------------------
%%

void yyerror(const char *format) {
	printf("[ERROR]\t");
	printf(format);
	printf("\n");
}

// forward arbitrary params to vprintf, this is an effective overload
void yyerror(const char *format, ...) {
	printf("[ERROR]\t");

	va_list args;
	va_start(args, format);
	vprintf(format, args);
	va_end(args);

	printf("\n");
}

int main(int argc, char *argv[]) {
	const char* input_file, * output_file;
	if (argc > 1) {
		input_file = argv[1];
	}
	else {
		input_file = "TestFile.c0";
	}
	if (argc > 2) {
		output_file = argv[2];
	}
	else {
		output_file = "TestFile.tree";
	}
	FILE* fp = fopen(input_file, "r");
	extern FILE* tree_out_f;
	tree_out_f = fopen(output_file, "w+");
	if (fp == NULL) {
		yyerror("Cannot open file \'%s\'", input_file);
		return -1;
	}
	if (tree_out_f == NULL) {
		yyerror("Cannot open file \'%s\'", output_file);
		return -1;
	}

	// altering the yyin(default stdin) to the test file 
	extern FILE* yyin;
	yyin = fp;

	printf("-----begin parsing %s-----\n", input_file);
	yyparse();
	printf("-----end parsing-----\n");

	fclose(fp);
	fclose(tree_out_f);
	return 0;
}
