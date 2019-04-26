/**
* Task 1: Lexical analyser
* Authors:
*	Josep Calero Santo
*	Pablo Gimeno Sarroca
*	Hatim Kaddouch
* Date:
*	28/04/2019
* Version 1.0
**/

%option caseless

%{
    #include <stdio.h>
    #include <stddef.h>
    #include "llist.h"

    char* states;
    int detecting_states = 0;

    llist *alphabet;
    llist *transitions;

%}

SIMBOLO         [a-zA-Z0-9]+
ABRIR           "{"
CERRAR          "}"
COMA            ","
split           [ \n\t\r]*
number          0|[1-9][0-9]*
transition      \({split}{number}{split}\,{split}{SIMBOLO}{split}\;{split}{number}{split}\)

%%

"%".*\n         { printf("Found a comment\n"); }

"Alfabeto"      { printf("Found an Alphabet declaration\n"); }
"Estados"       { detecting_states = 1; printf("Found a declaration of States\n"); }
"Transiciones"  { printf("Found a declaration of Transitions\n"); }
"Inicial"       { printf("Found a declaration of Initial\n"); }
"Finales"       { printf("Found a declaration of Finals\n"); }

{transition}    { printf("Found a transition\n"); llist_push(transitions, strdup(yytext));}
{split}         { printf("Found a separator\n"); }
{number}        { if (detecting_states == 1) {
                    states = strdup(yytext);
                    detecting_states = 0;
                    printf("Found a number of states\n");
                  }
                  else {
                    printf("Found a number\n");
                  }
                }

{SIMBOLO}       { printf("Found token 'SIMBOLO'\n"); llist_push(alphabet, strdup(yytext));}
{ABRIR}         { printf("Found token 'ABRIR'\n"); }
{CERRAR}        { printf("Found token 'CERRAR'\n"); }
{COMA}          { printf("Found token 'COMA'\n"); }

.               { printf("<<error:%s>>\n", yytext); }
<<EOF>>         { yyterminate(); }

%%

int main(int argc, char const *argv[])
{
    if (argc > 1)
    {
        if (!(yyin = fopen(argv[1], "r")))
        {
            perror(argv[1]);
            return 1;
        }
    }

    alphabet = llist_create(NULL);
    transitions = llist_create(NULL);

    yylex();
    printf("\n=======================================\nLexical recognition finished\n\nNumber of states = %s\
    \n\nTransitions:\n\n", states);
    llist_print(transitions, printf);
    printf("\nAlphabet:\n\n");
    llist_print(alphabet, printf);
    printf("=======================================\n");


    llist_free(alphabet);
    llist_free(transitions);
}
