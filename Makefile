out : lex.yy.c llist.o
	gcc lex.yy.c llist.o -lfl

lex.yy.c :
	flex AF.l

llist.o : llist.c
	gcc -c -o llist.o llist.c

clean :
	rm -f llist.o *.exe *.out lex.yy.c
