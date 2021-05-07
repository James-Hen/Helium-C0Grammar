/*
 *	C0Lex.l: flex input file, which implements C0 lex
 *	Author: James Zhang
 */

%{

#include "Common.h"
#include "C0Grammar.tab.h"

extern "C" {
	int yywrap(void);
	int yylex(void);
}

void lhint(const char* format, ...) {
	printf("[LEXHINTS] ");

	va_list args;
	va_start(args, format);
	vprintf(format, args);
	va_end(args);

	printf("\n");
}

%}

%x COMMENT

nondigit	([_A-Za-z])

digit		([0-9])

integer		({digit}+)

float		(({digit}+.{digit}*)|({digit}*.{digit}+))

character	(\'(\\.|[^'])\')

string		(\"(\\.|[^\"])*\")

identifier	({nondigit}({nondigit}|{digit})*)

blank_chars	([ \f\r\t\v]+)


/* ------------------Rule Section------------------*/
/* generate the kwrules and oprules from GenKwRule.py */
%%
"int"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("int"); return _INT; }
"bool"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("bool"); return _BOOL; }
"string"		{ lhint("kw:\t%s", yytext); yylval.node = newnode("string"); return _STRING; }
"char"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("char"); return _CHAR; }
"void"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("void"); return _VOID; }
"struct"		{ lhint("kw:\t%s", yytext); yylval.node = newnode("struct"); return _STRUCT; }
"typedef"		{ lhint("kw:\t%s", yytext); yylval.node = newnode("typedef"); return _TYPEDEF; }
"if"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("if"); return _IF; }
"else"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("else"); return _ELSE; }
"while"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("while"); return _WHILE; }
"for"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("for"); return _FOR; }
"continue"		{ lhint("kw:\t%s", yytext); yylval.node = newnode("continue"); return _CONTINUE; }
"break"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("break"); return _BREAK; }
"return"		{ lhint("kw:\t%s", yytext); yylval.node = newnode("return"); return _RETURN; }
"assert"		{ lhint("kw:\t%s", yytext); yylval.node = newnode("assert"); return _ASSERT; }
"error"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("error"); return _ERROR; }
"true"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("true"); return _TRUE; }
"false"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("false"); return _FALSE; }
"NULL"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("NULL"); return _NULL; }
"alloc"			{ lhint("kw:\t%s", yytext); yylval.node = newnode("alloc"); return _ALLOC; }
"alloc_array"	{ lhint("kw:\t%s", yytext); yylval.node = newnode("alloc_array"); return _ALLOC_ARRAY; }

">>="			{ lhint("op:\t%s", yytext); yylval.node = newnode(">>="); return RIGHT_ASSIGN; }
"<<="			{ lhint("op:\t%s", yytext); yylval.node = newnode("<<="); return LEFT_ASSIGN; }
"+="			{ lhint("op:\t%s", yytext); yylval.node = newnode("+="); return ADD_ASSIGN; }
"-="			{ lhint("op:\t%s", yytext); yylval.node = newnode("-="); return SUB_ASSIGN; }
"*="			{ lhint("op:\t%s", yytext); yylval.node = newnode("*="); return MUL_ASSIGN; }
"/="			{ lhint("op:\t%s", yytext); yylval.node = newnode("/="); return DIV_ASSIGN; }
"%="			{ lhint("op:\t%s", yytext); yylval.node = newnode("%="); return MOD_ASSIGN; }
"&="			{ lhint("op:\t%s", yytext); yylval.node = newnode("&="); return AND_ASSIGN; }
"^="			{ lhint("op:\t%s", yytext); yylval.node = newnode("^="); return XOR_ASSIGN; }
"|="			{ lhint("op:\t%s", yytext); yylval.node = newnode("|="); return OR_ASSIGN; }
">>"			{ lhint("op:\t%s", yytext); yylval.node = newnode(">>"); return RIGHT_OP; }
"<<"			{ lhint("op:\t%s", yytext); yylval.node = newnode("<<"); return LEFT_OP; }
"++"			{ lhint("op:\t%s", yytext); yylval.node = newnode("++"); return INC_OP; }
"--"			{ lhint("op:\t%s", yytext); yylval.node = newnode("--"); return DEC_OP; }
"->"			{ lhint("op:\t%s", yytext); yylval.node = newnode("->"); return PTR_OP; }
"&&"			{ lhint("op:\t%s", yytext); yylval.node = newnode("&&"); return AND_OP; }
"||"			{ lhint("op:\t%s", yytext); yylval.node = newnode("||"); return OR_OP; }
"<="			{ lhint("op:\t%s", yytext); yylval.node = newnode("<="); return LE_OP; }
">="			{ lhint("op:\t%s", yytext); yylval.node = newnode(">="); return GE_OP; }
"=="			{ lhint("op:\t%s", yytext); yylval.node = newnode("=="); return EQ_OP; }
"!="			{ lhint("op:\t%s", yytext); yylval.node = newnode("!="); return NE_OP; }

";"				{ lhint("op:\t%s", yytext); yylval.node = newnode(";"); return ';'; }
"{"				{ lhint("op:\t%s", yytext); yylval.node = newnode("{"); return '{'; }
"}"				{ lhint("op:\t%s", yytext); yylval.node = newnode("}"); return '}'; }
","				{ lhint("op:\t%s", yytext); yylval.node = newnode(","); return ','; }
":"				{ lhint("op:\t%s", yytext); yylval.node = newnode(":"); return ':'; }
"="				{ lhint("op:\t%s", yytext); yylval.node = newnode("="); return '='; }
"("				{ lhint("op:\t%s", yytext); yylval.node = newnode("("); return '('; }
")"				{ lhint("op:\t%s", yytext); yylval.node = newnode(")"); return ')'; }
"["				{ lhint("op:\t%s", yytext); yylval.node = newnode("["); return '['; }
"]"				{ lhint("op:\t%s", yytext); yylval.node = newnode("]"); return ']'; }
"."				{ lhint("op:\t%s", yytext); yylval.node = newnode("."); return '.'; }
"&"				{ lhint("op:\t%s", yytext); yylval.node = newnode("&"); return '&'; }
"!"				{ lhint("op:\t%s", yytext); yylval.node = newnode("!"); return '!'; }
"~"				{ lhint("op:\t%s", yytext); yylval.node = newnode("~"); return '~'; }
"-"				{ lhint("op:\t%s", yytext); yylval.node = newnode("-"); return '-'; }
"+"				{ lhint("op:\t%s", yytext); yylval.node = newnode("+"); return '+'; }
"*"				{ lhint("op:\t%s", yytext); yylval.node = newnode("*"); return '*'; }
"/"				{ lhint("op:\t%s", yytext); yylval.node = newnode("/"); return '/'; }
"%"				{ lhint("op:\t%s", yytext); yylval.node = newnode("%"); return '%'; }
"<"				{ lhint("op:\t%s", yytext); yylval.node = newnode("<"); return '<'; }
">"				{ lhint("op:\t%s", yytext); yylval.node = newnode(">"); return '>'; }
"^"				{ lhint("op:\t%s", yytext); yylval.node = newnode("^"); return '^'; }
"|"				{ lhint("op:\t%s", yytext); yylval.node = newnode("|"); return '|'; }
"?"				{ lhint("op:\t%s", yytext); yylval.node = newnode("?"); return '?'; }


{identifier}	{ lhint("id:\t%s", yytext); yylval.node = newnode(yytext); return IDENTIFIER; }

{integer}		{ lhint("i:\t%s", yytext); yylval.node = newnode(yytext); return INTEGER; }

{float}			{ lhint("fl:\t%s", yytext); yylval.node = newnode(yytext); return FLOAT; }

{character}		{ lhint("ch:\t%s", yytext); yylval.node = newnode(yytext); return CHAR_LITERAL; }

{string}		{ lhint("s:\t%s", yytext); yylval.node = newnode(yytext); return STRING_LITERAL; }

{blank_chars}	{ }
				
\n				{ lhint("newline"); }
"//"			{ lhint("comment"); BEGIN COMMENT; }
"#"				{ lhint("preproc"); BEGIN COMMENT; }

<COMMENT>\n		{ BEGIN INITIAL; }

<COMMENT>.		{ }

%%
/* ------------------Subroutine Section------------------*/

int yywrap(void) {
	puts("-----Lex: The File Ends-----\n");
	return 1;
}
