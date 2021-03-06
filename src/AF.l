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
	int errors=0;

%}

SIMBOLO         [a-zA-Z0-9]
ABRIR           "{"
CERRAR          "}"
COMA            ","
newline         [\n\r]
split           [ \t]*
num             0|[1-9][0-9]*
transition      \({split}{num}{split}\,{split}{SIMBOLO}{split}\;{split}{num}{split}\)
alfabeto	    [Aa][Ll][Ff][Aa][Bb][Ee][Tt][Oo]
estados		    [Ee][Ss][Tt][Aa][Dd][Oo][Ss]
transiciones	[Tt][Rr][Aa][Nn][Ss][Ii][Cc][Ii][Oo][Nn][Ee][Ss]
inicial		    [Ii][Nn][Ii][Cc][Ii][Aa][Ll]
final           [Ff][Ii][Nn][Aa][Ll][Ee][Ss]

%%

"%".*{newline}        { printf("Found a comment\n"); }

{alfabeto}      { printf("Found an Alphabet declaration\n"); }
{estados}       { printf("Found a declaration of States\n"); detecting_states = 1; }
{transiciones}  { printf("Found a declaration of Transitions\n"); }
{inicial}       { printf("Found a declaration of Initial state\n"); detecting_initial = 1;}
{final}         { printf("Found a declaration of Final states\n"); detecting_finals = 1;}

{transition}    { printf("Found a transition\n"); llist_push(transitions, strdup(yytext));}
{split}         { printf("Found a separator\n"); }
{newline}       { printf("Found a new line\n");}
{num}           { if (detecting_states)
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
                  if (detecting_finals) detecting_finals = 0;
                }
{COMA}          { printf("Found token 'COMA'\n"); }

.               { printf("<<error:%s>>\n", yytext); errors=errors+1;}
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
	printf("Errors found: %i",errors);
}
