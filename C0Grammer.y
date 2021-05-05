/*
 *	C0Grammer.y: bison/yayacc input file, which describes C0 but not well implemented
 *	Author: James Zhang
 */

// Define Section
%{
#include "Common.h"

extern "C" {
	void yyerror(const char *s);
	extern int yylex(void);
}
%}

%union {
    double literal_float_value;
	int literal_int_value;
    char* string_content;
}

%token<string_content> IDENTIFIER
// keywords in C0 (not fully supported)
%token<string_content> _INT _BOOL _STRING _CHAR _VOID _STRUCT _TYPEDEF _IF _ELSE _WHILE _FOR _CONTINUE _BREAK _RETURN _ASSERT _ERROR _TRUE _FALSE _NULL _ALLOC _ALLOC_ARRAY
// operators in C0
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP
%token EQ_OP NE_OP AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
// preprocess words
%token USE 						// #use
// literals
%token<literal_int_value> INTEGER
%token<literal_float_value> FLOAT
%type<string_content> STRING_LITERAL
%type<string_content> LIB_LITERAL

// non-terminals
%type<string_content> prog

%type<string_content> cdecl		// declaration
%type<string_content> args

%type<string_content> cdefn		// defination
%type<string_content> field_defn decl_assign body

%type<string_content> stmt else_stmt simple null_simple expr null_expr
%type<string_content> lftval

%token<string_content> type
%token<string_content> operator asn_op

%%
// Rule Section

prog		:	cdecl prog
				{

				}
			|	cdefn prog
				{

				}
			;

cdecl		:	_STRUCT IDENTIFIER ';'
				{

				}
			|	type IDENTIFIER '(' args ')' ';'
				{

				}
			|	USE LIB_LTERAL
				{

				}
			|	USE STRING_LITERAL
				{

				}
			;

args		:	type IDENTIFIER ',' args
				{

				}
			|	%empty
				{

				}
			;

cdefn		:	_STRUCT IDENTIFIER ';' '{' field_defn '}'
				{

				}
			|	type IDENTIFIER '(' args ')' ';' '{' body '}'
				{

				}
			|	_TYPEDEF type IDENTIFIER ';'
				{

				}
			;

field_defn	:	type IDENTIFIER decl_assign ';' field_defn
				{

				}
			|	%empty
				{

				}
			;

decl_assign	:	'=' expr decl_assign
				{

				}
			|	%empty
				{

				}
			;

body		:	stmt body
				{

				}
			|	%empty
				{

				}
			;

stmt 		:	simple ';'
			|	_IF '(' expr ')' stmt else_stmt
			|	_WHILE '(' expr ')' stmt
			|	_FOR '(' null_simple ';' expr ';' null_simple ')' stmt
			|	_RETURN null_expr ';'
			|	'{' body '}'
			|	_ASSERT '(' expr ')' ';'
			|	_ERROR '(' expr ')' ';'
			;

else_stmt	:	_ELSE stmt
			|	%empty
			;

simple		|	lftval asn_op expr
			|	lftval "++"
			|	lftval "--"
			|	expr
			|	type <vid> ['=' expr]
			;

null_simple	|	simple
			|	%empty
			;

lftval		:	<vid> | lftval . <fid> | lftval -> <fid>
			|	* lftval | lftval [ expr ] | ( lftval )
			;

type		:	_INT | _BOOL | _STRING | _CHAR | _VOID
			|	type '*' | type '[' ']' | _STRUCT IDENTIFIER | IDENTIFIER
			;

expr 		:	( expr )
			|	<num> | <strlit> | <chrlit> | true | false | NULL
			|	<vid> | expr <binop> expr | <unop> expr
			|	expr ? expr : expr
			|	<vid> ( [expr (, expr)*] )
			|	expr . <fid> | expr -> <fid>
			|	expr [ expr ]
			|	alloc ( type ) | alloc_array ( type , expr )
			;

null_expr	|	expr
			|	%empty
			;


%%
// Subroutine Section

void yyerror(const char *format) {
	printf(format);
}

// forward arbitrary params to vprintf, this is an effective overload
void yyerror(const char *format, ...) {
	va_list args;

	va_start(args, format);
	vprintf(format, args);
	va_end(args);
}

int main(int argc, char *argv[]) {
	const char* input_file;
	if (argc > 1) {
		input_file = argv[1];
	}
	else {
		input_file = "TestFile.c0";
	}
	FILE* fp = fopen(input_file, "r");
	if (fp == NULL) {
		yyerror("ERROR: Cannot open file \'%s\'\n", input_file);
		return -1;
	}

	// altering the yyin(default stdin) to the test file 
	extern FILE* yyin;
	yyin = fp;

	printf("-----begin parsing %s\n-----", input_file);
	yyparse();
	printf("-----end parsing-----");

	fclose(fp);
	return 0;
}
