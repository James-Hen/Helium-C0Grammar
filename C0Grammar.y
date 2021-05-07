/*
 *	C0Grammer.y: bison/yayacc input file, fully implements C0 language
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
// keywords in C0
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
				{ root = $$ = setputn("ROOT", 1, $1); }
			;

prog		:	cdecl prog
				{ $$ = setputn("prog", 2, $1, $2); }
			|	cdefn prog
				{ $$ = setputn("prog", 2, $1, $2); }
			|	%empty
				{ $$ = setputn("prog", 0); }
			;
cdecl		:	_STRUCT IDENTIFIER ';'
				{ $$ = setputn("cdecl", 3, $1, $2, $3); }
			|	type IDENTIFIER '(' args ')' ';'
				{ $$ = setputn("cdecl", 6, $1, $2, $3, $4, $5, $6); }
			;
cdefn		:	_STRUCT IDENTIFIER '{' field_defn '}' ';'
				{ $$ = setputn("cdefn", 6, $1, $2, $3, $4, $5, $6); }
			|	type IDENTIFIER '(' args ')' body
				{ $$ = setputn("cdefn", 6, $1, $2, $3, $4, $5, $6); }
			|	_TYPEDEF type IDENTIFIER ';'
				{ $$ = setputn("cdefn", 4, $1, $2, $3, $4); }
			;
args		:	type IDENTIFIER rght_args
				{ $$ = setputn("args", 3, $1, $2, $3); }
			|	%empty
				{ $$ = setputn("args", 0); }
			;
rght_args	:	',' type IDENTIFIER
				{ $$ = setputn("rght_args", 3, $1, $2, $3); }
			|	%empty
				{ $$ = setputn("rght_args", 0); }
			;
field_defn	:	type IDENTIFIER decl_assign ';' field_defn
				{ $$ = setputn("field_defn", 5, $1, $2, $3, $4, $5); }
			|	%empty
				{ $$ = setputn("field_defn", 0); }
			;
type		:	_INT
				{ $$ = setputn("type", 1, $1); }
			|	_BOOL
				{ $$ = setputn("type", 1, $1); }
			|	_STRING
				{ $$ = setputn("type", 1, $1); }
			|	_CHAR
				{ $$ = setputn("type", 1, $1); }
			|	_VOID
				{ $$ = setputn("type", 1, $1); }
			|	type '*'
				{ $$ = setputn("type", 2, $1, $2); }
			|	type '[' ']'
				{ $$ = setputn("type", 3, $1, $2, $3); }
			|	_STRUCT IDENTIFIER
				{ $$ = setputn("type", 2, $1, $2); }
			|	IDENTIFIER
				{ $$ = setputn("type", 1, $1); }
			;
decl_assign	:	'=' expr decl_assign
				{ $$ = setputn("decl_assign", 3, $1, $2, $3); }
			|	%empty
				{ $$ = setputn("decl_assign", 0); }
			;
body		:	'{' stmts '}'
				{ $$ = setputn("body", 3, $1, $2, $3); }
			;
stmts		:	stmt stmts
				{ $$ = setputn("stmts", 2, $1, $2); }
			|	%empty
				{ $$ = setputn("stmts", 0); }
			;
stmt		:	simple ';'
				{ $$ = setputn("stmt", 2, $1, $2); }
			|	_RETURN null_expr ';'
				{ $$ = setputn("stmt", 3, $1, $2, $3); }
			|	_IF '(' expr ')' body else_stmt
				{ $$ = setputn("stmt", 6, $1, $2, $3, $4, $5, $6); }
			|	_WHILE '(' expr ')' body
				{ $$ = setputn("stmt", 5, $1, $2, $3, $4, $5); }
			|	_FOR '(' null_simple ';' expr ';' null_simple ')' body
				{ $$ = setputn("stmt", 9, $1, $2, $3, $4, $5, $6, $7, $8, $9); }
			|	body
				{ $$ = setputn("stmt", 1, $1); }
			|	_ASSERT '(' expr ')' ';'
				{ $$ = setputn("stmt", 5, $1, $2, $3, $4, $5); }
			|	_ERROR '(' expr ')' ';'
				{ $$ = setputn("stmt", 5, $1, $2, $3, $4, $5); }
			;
else_stmt	:	_ELSE body
				{ $$ = setputn("else_stmt", 2, $1, $2); }
			|	%empty
				{ $$ = setputn("else_stmt", 0); }
			;
simple		:	lftval asn_op expr
				{ $$ = setputn("simple", 3, $1, $2, $3); }
			|	lftval INC_OP
				{ $$ = setputn("simple", 2, $1, $2); }
			|	lftval DEC_OP
				{ $$ = setputn("simple", 2, $1, $2); }
			|	expr
				{ $$ = setputn("simple", 1, $1); }
			|	type IDENTIFIER decl_assign
				{ $$ = setputn("simple", 3, $1, $2, $3); }
			;
null_simple	:	simple
				{ $$ = setputn("null_simple", 1, $1); }
			|	%empty
				{ $$ = setputn("null_simple", 0); }
			;
lftval		:	IDENTIFIER
				{ $$ = setputn("lftval", 1, $1); }
			|	lftval '.' IDENTIFIER
				{ $$ = setputn("lftval", 3, $1, $2, $3); }
			|	lftval PTR_OP IDENTIFIER
				{ $$ = setputn("lftval", 3, $1, $2, $3); }
			|	'*' lftval
				{ $$ = setputn("lftval", 2, $1, $2); }
			|	lftval '[' expr ']'
				{ $$ = setputn("lftval", 4, $1, $2, $3, $4); }
			|	'(' lftval ')'
				{ $$ = setputn("lftval", 3, $1, $2, $3); }
			;
expr		:	'(' expr ')'
				{ $$ = setputn("expr", 3, $1, $2, $3); }
			|	number
				{ $$ = setputn("expr", 1, $1); }
			|	STRING_LITERAL
				{ $$ = setputn("expr", 1, $1); }
			|	CHAR_LITERAL
				{ $$ = setputn("expr", 1, $1); }
			|	_TRUE
				{ $$ = setputn("expr", 1, $1); }
			|	_FALSE
				{ $$ = setputn("expr", 1, $1); }
			|	_NULL
				{ $$ = setputn("expr", 1, $1); }
			|	IDENTIFIER
				{ $$ = setputn("expr", 1, $1); }
			|	expr bin_op expr
				{ $$ = setputn("expr", 3, $1, $2, $3); }
			|	un_op expr
				{ $$ = setputn("expr", 2, $1, $2); }
			|	expr '?' expr ':' expr
				{ $$ = setputn("expr", 5, $1, $2, $3, $4, $5); }
			|	IDENTIFIER '(' params ')'
				{ $$ = setputn("expr", 4, $1, $2, $3, $4); }
			|	expr '.' IDENTIFIER
				{ $$ = setputn("expr", 3, $1, $2, $3); }
			|	expr PTR_OP IDENTIFIER
				{ $$ = setputn("expr", 3, $1, $2, $3); }
			|	expr '[' expr ']'
				{ $$ = setputn("expr", 4, $1, $2, $3, $4); }
			|	_ALLOC '(' type ')'
				{ $$ = setputn("expr", 4, $1, $2, $3, $4); }
			|	_ALLOC_ARRAY '(' type ',' expr ')'
				{ $$ = setputn("expr", 6, $1, $2, $3, $4, $5, $6); }
			;
null_expr	:	expr
				{ $$ = setputn("null_expr", 1, $1); }
			|	%empty
				{ $$ = setputn("null_expr", 0); }
			;
params		:	expr rght_params
				{ $$ = setputn("params", 2, $1, $2); }
			|	%empty
				{ $$ = setputn("params", 0); }
			;
rght_params	:	',' expr
				{ $$ = setputn("rght_params", 2, $1, $2); }
			|	%empty
				{ $$ = setputn("rght_params", 0); }
			;
un_op		:	'!'
				{ $$ = setputn("un_op", 1, $1); }
			|	'~'
				{ $$ = setputn("un_op", 1, $1); }
			|	'-'
				{ $$ = setputn("un_op", 1, $1); }
			;
bin_op		:	OR_OP
				{ $$ = setputn("bin_op", 1, $1); }
			|	AND_OP
				{ $$ = setputn("bin_op", 1, $1); }
			|	'|'
				{ $$ = setputn("bin_op", 1, $1); }
			|	'^'
				{ $$ = setputn("bin_op", 1, $1); }
			|	'&'
				{ $$ = setputn("bin_op", 1, $1); }
			|	'<'
				{ $$ = setputn("bin_op", 1, $1); }
			|	LE_OP
				{ $$ = setputn("bin_op", 1, $1); }
			|	EQ_OP
				{ $$ = setputn("bin_op", 1, $1); }
			|	NE_OP
				{ $$ = setputn("bin_op", 1, $1); }
			|	GE_OP
				{ $$ = setputn("bin_op", 1, $1); }
			|	'>'
				{ $$ = setputn("bin_op", 1, $1); }
			|	RIGHT_OP
				{ $$ = setputn("bin_op", 1, $1); }
			|	LEFT_OP
				{ $$ = setputn("bin_op", 1, $1); }
			|	'*'
				{ $$ = setputn("bin_op", 1, $1); }
			|	'/'
				{ $$ = setputn("bin_op", 1, $1); }
			|	'%'
				{ $$ = setputn("bin_op", 1, $1); }
			|	'+'
				{ $$ = setputn("bin_op", 1, $1); }
			|	'-'
				{ $$ = setputn("bin_op", 1, $1); }
			;
asn_op		:	'='
				{ $$ = setputn("asn_op", 1, $1); }
			|	MUL_ASSIGN
				{ $$ = setputn("asn_op", 1, $1); }
			|	DIV_ASSIGN
				{ $$ = setputn("asn_op", 1, $1); }
			|	MOD_ASSIGN
				{ $$ = setputn("asn_op", 1, $1); }
			|	ADD_ASSIGN
				{ $$ = setputn("asn_op", 1, $1); }
			|	SUB_ASSIGN
				{ $$ = setputn("asn_op", 1, $1); }
			|	LEFT_ASSIGN
				{ $$ = setputn("asn_op", 1, $1); }
			|	RIGHT_ASSIGN
				{ $$ = setputn("asn_op", 1, $1); }
			|	AND_ASSIGN
				{ $$ = setputn("asn_op", 1, $1); }
			|	XOR_ASSIGN
				{ $$ = setputn("asn_op", 1, $1); }
			|	OR_ASSIGN
				{ $$ = setputn("asn_op", 1, $1); }
			;
number		:	INTEGER
				{ $$ = setputn("number", 1, $1); }
			|	FLOAT
				{ $$ = setputn("number", 1, $1); }
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
	FILE* fp = fopen(input_file, "r"), * tree_out_f = fopen(output_file, "w+");
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

	trav_outputf(tree_out_f, root);
	trav_delete(root);

	fclose(fp);
	fclose(tree_out_f);
	return 0;
}
