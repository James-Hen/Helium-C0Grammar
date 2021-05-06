kwlist = ["int", "bool", "string", "char", "void", "struct", "typedef", "if", "else", "while", "for", "continue", "break", "return", "assert", "error", "true", "false", "NULL", "alloc", "alloc_array"]

# named ops (often have multiple characters)
named_op = [
	(">>=", "RIGHT_ASSIGN"),
	("<<=", "LEFT_ASSIGN"),
	("+=", "ADD_ASSIGN"),
	("-=", "SUB_ASSIGN"),
	("*=", "MUL_ASSIGN"),
	("/=", "DIV_ASSIGN"),
	("%=", "MOD_ASSIGN"),
	("&=", "AND_ASSIGN"),
	("^=", "XOR_ASSIGN"),
	("|=", "OR_ASSIGN"),
	(">>", "RIGHT_OP"),
	("<<", "LEFT_OP"),
	("++", "INC_OP"),
	("--", "DEC_OP"),
	("->", "PTR_OP"),
	("&&", "AND_OP"),
	("||", "OR_OP"),
	("<=", "LE_OP"),
	(">=", "GE_OP"),
	("==", "EQ_OP"),
	("!=", "NE_OP")
	]

# literally defined ops
lit_op = [";", "{", "}", ",", ":", "=", "(", ")", "[", "]", ".", "&", "!", "~", "-", "+", "*", "/", "%", "<", ">", "^", "|", "?"]

def indent(str):
	res = ""
	for i in range(0, 4 - (len(str)+2)//4):
		res += "\t"
	return res

with open('DevUtils/rule.txt', 'w+') as f:
	for kw in kwlist:
		f.write('"' + kw + '"' + indent(kw) + '''{ lhint("kw:\\t%s", yytext); yylval.node = newnode("''' + kw + '''"); return ''' + '_' + kw.upper() + '''; }\n''')
	f.write("\n")
	for kw, nm in named_op:
		f.write('"' + kw + '"' + indent(kw) + '''{ lhint("op:\\t%s", yytext); yylval.node = newnode("''' + kw + '''"); return ''' + nm + '''; }\n''')
	f.write("\n")
	for kw in lit_op:
		f.write('"' + kw + '"' + indent(kw) + '''{ lhint("op:\\t%s", yytext); yylval.node = newnode("''' + kw + '''"); return ''' + "'" + kw + "'" + '''; }\n''')