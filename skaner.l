%option noyywrap 

%{
#include <string>
#include <vector>
#include <iostream>
#include <cstring>
#include "instruction.h"
#include "y.tab.h"
int yyparse();


void yylval_to_vname(char* s);
%}

%%
"PRINT" return PRINT;
"IF" return IF;
"WHILE" return WHILE;

[A-Za-z][A-Za-z0-9]* {
	yylval.vName = new std::string(yytext);
	return VAR;
}

[A-Za-z0-9\+\-\*\/\(\)\^\#\!\%\.]+ {
	yylval.vName = new std::string(yytext);
	return EQUATION;
}

"=="|">"|">="|"<"|"<="|"!=" {
	yylval.vName = new std::string(yytext);
	return SIGN;
}

[\=\;] {
	return yytext[0];
}

[ \t\n] ;
.	{
	return UNK;
}
%%

// void yylval_to_vname(std::string s){
// 	std::string str(s);
// 	yylval.vName = new std::string(str.length()+1);
// 	strcpy(yylval.vName, str.c_str());
// }

void yyerror(std::string msg){
	std::cerr << "Error: " << msg << "!\n";
}