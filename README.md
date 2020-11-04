# compiler-design-project

files named array references and expression involving variables contain the basics of assembly language or the logic.

lang.l : This file is a lexical anaylser which searchs for vaild key words that is used in our program. when we run "lex lang.l" file in command prompt, this will generate lex.yy.c

lang.y : In this file we are defining our rules(grammar) for which, what action we have to take. when we run "yacc -d lang.y" file in command prompt, this will generate y.tab.c and y.tab.h for our compiler

codegen.c : This contains the actions we are taking in lang.y file.

After linking lex.yy.c and y.tab.c our .exe is generated for our compiler.


HOW TO COMPILE:
yacc -d lang.y
lex lang.l
gcc -ll lang.tab.c -o base
#run parser
/base {input filename} {output filename}
or
/base {input filename}
