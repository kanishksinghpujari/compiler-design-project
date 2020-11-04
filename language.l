%{

	#include <stdlib.h>
	#include <stdio.h>
	#include "lang.tab.h"
	void yyerror(char *);
	#define DEBUG_OUT 0
	int yylineno;
%}

digit [0-9]
small_letter [a-z]
capital_letter [A-Z]
whitespace [ \t]+

%%

{digit}+ { 
	yylval = atoi(yytext);
	if (DEBUG_OUT)
		printf("Found integer: %d\n", yylval);
	return INT;
}

{small_letter} {
	/* Single char variables. Case-invariant */
	yylval = *yytext-'a';
	if (DEBUG_OUT)
		printf("Found variable: %c\n", *yytext);
	return VAR;
}
{capital_letter} {
	yylval = *yytext-'A';
	if (DEBUG_OUT)
		printf("Found variable: %c\n", *yytext);
	return VAR;
}
main {
	if (DEBUG_OUT)
		printf("Found token: %s\n", yytext);
	return MAIN;
}
int {
	return (DINT);
}

"**" {
	if (DEBUG_OUT)
		printf("Found token: %s\n", yytext);
	return POW;
}

[-()<>=+*/&|;{}] {
	if (DEBUG_OUT)
		printf("Found token: %c\n", *yytext);
	return *yytext;
}

"print" {
	if (DEBUG_OUT)
		printf("Found token: %s\n", yytext);
	return PRINT;
}
[\n\r] {
	if (DEBUG_OUT)
		printf("Incrementing linenum\n");
	yylineno++;
}
{whitespace}	 ;

. {
	yyerror("Unknown token");
}
%%
