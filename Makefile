a.exe:
	flex analyzer.l
	gcc -c -o llist.o llist.c
	gcc lex.yy.c llist.o -lfl
