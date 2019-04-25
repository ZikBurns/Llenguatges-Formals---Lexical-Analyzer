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
    #define FALSE 0
    #define TRUE 1
    char* num_estados;
    int es_num_estados = FALSE;
%}
SIMBOLO         [a-zA-Z0-9]+
ABRIR           "{"
CERRAR          "}"
COMA            ","

sep             [ \n\t\r]*
num             0|[1-9][0-9]*
transicion      \({sep}{num}{sep}\,{sep}{SIMBOLO}{sep}\;{sep}{num}{sep}\)
%%
"%".*\n         { printf("Found a comment\n"); }

"Alfabeto"      { printf("Found an Alphabet declaration\n"); }
"Estados"       { es_num_estados = TRUE; printf("Found a declaration of States\n"); } 
"Transiciones"  { printf("Found a declaration of Transitions\n"); }
"Inicial"       { printf("Found a declaration of Initial\n"); }
"Finales"       { printf("Found a declaration of Finals\n"); }
{num}           { if (es_num_estados == TRUE) { num_estados = strdup(yytext); es_num_estados = FALSE; } printf("num\n"); }

{SIMBOLO}       { printf("Found token 'SIMBOLO'\n"); }
{ABRIR}         { printf("Found token 'ABRIR'\n"); }
{CERRAR}        { printf("Found token 'CERRAR'\n"); }
{COMA}          { printf("Found token 'COMA'\n"); }

{sep}           { printf("Found a separator\n"); }
{transicion}    { printf("Found a transition\n"); }

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
    yylex(); 
    printf("\nStates found = %s\n", num_estados);
}
