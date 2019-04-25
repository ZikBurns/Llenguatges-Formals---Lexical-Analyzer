#!/bin/bash
flex analyzer.l
gcc lex.yy.c -lfl
