a.exe:
	flex analyzer.l
	gcc lex.yy.c -lfl
