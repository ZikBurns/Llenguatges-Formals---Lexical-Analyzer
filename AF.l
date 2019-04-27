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
    int detecting_finals = 0;
    int detecting_initial = 0;

    llist *alphabet;
    llist *transitions;
    llist *final_states;
    char * initial_state;

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
"Estados"       { printf("Found a declaration of States\n"); detecting_states = 1; }
"Transiciones"  { printf("Found a declaration of Transitions\n"); }
"Inicial"       { printf("Found a declaration of Initial\n"); detecting_initial = 1;}
"Finales"       { printf("Found a declaration of Finals\n"); detecting_finals = 1;}

{transition}    { printf("Found a transition\n"); llist_push(transitions, strdup(yytext));}
{split}         { printf("Found a separator\n"); }
{number}        { if (detecting_states)
                  {
                    states = strdup(yytext);
                    detecting_states = 0;
                  }
                  else if (detecting_initial)
                  {
                    initial_state = strdup(yytext);
                    detecting_initial = 0;
                  }
                  else if (detecting_finals)
                  {
                    llist_push(final_states, strdup(yytext));
                  }
        				  else if ((*(strdup(yytext))>='0')&&(*(strdup(yytext))<='9'))
        				  {
        					printf("Found token 'SIMBOLO'\n"); llist_push(alphabet, strdup(yytext));
        				  }
                }

{SIMBOLO}       { printf("Found token 'SIMBOLO'\n"); llist_push(alphabet, strdup(yytext));}
{ABRIR}         { printf("Found token 'ABRIR'\n"); }
{CERRAR}        { printf("Found token 'CERRAR'\n");
                  if (detecting_finals == 1) detecting_finals = 0;
                }
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
    final_states = llist_create(NULL);

    yylex();
    printf("\n================================================================================\
    \nLexical recognition finished\n\n");
    printf("Alphabet:\n\n");
    llist_print(alphabet);
    printf("\n\nNumber of states = %s", states);
    printf("\n\n\nTransitions:\n\n");
    llist_print(transitions);
    printf("\n\nInitial state = %s\n\n", initial_state);
    printf("\nFinal states:\n\n");
    llist_print(final_states);
    printf("================================================================================\n");

    llist_free(alphabet);
    llist_free(transitions);
    llist_free(final_states);
}
