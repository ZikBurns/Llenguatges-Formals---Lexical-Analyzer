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
    char* states;
    int detecting_states = 0;
%}
SIMBOLO         [a-zA-Z0-9]+
ABRIR           "{"
CERRAR          "}"
COMA            ","
split             [ \n\t\r]*
num             0|[1-9][0-9]*
transicion      \({split}{num}{split}\,{split}{SIMBOLO}{split}\;{split}{num}{split}\)
%%
"%".*\n         { printf("Found a comment\n"); }
"Alfabeto"      { printf("Found an Alphabet declaration\n"); }
"Estados"       { detecting_states = 1; printf("Found a declaration of States\n"); } 
"Transiciones"  { printf("Found a declaration of Transitions\n"); }
"Inicial"       { printf("Found a declaration of Initial\n"); }
"Finales"       { printf("Found a declaration of Finals\n"); }
{transicion}    { printf("Found a transition\n"); }
{num}           { if (detecting_states == 1) { states = strdup(yytext); detecting_states = 0; } printf("num\n"); }
{SIMBOLO}       { printf("Found token 'SIMBOLO'\n"); }
{ABRIR}         { printf("Found token 'ABRIR'\n"); }
{CERRAR}        { printf("Found token 'CERRAR'\n"); }
{COMA}          { printf("Found token 'COMA'\n"); }
{split}         { printf("Found a separator\n"); }
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
    printf("\nLexical recognition finished. \n\tStates found = %s\n", states);
}
