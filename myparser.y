%{
    #include <stdio.h>
    #include "cgen.h"

    extern int yylex(void);
    extern int lineNum;
%}

%union
{
  char* str;
}

%token KW_AND
%token KW_NUMBER
%token KW_BOOL
%token KW_STRING
%token KW_VOID
%token KW_TRUE
%token KW_FALSE
%token KW_ELSE
%token KW_FOR
%token KW_CONST
%token KW_FUNCTION
%token KW_BREAK
%token KW_IF
%token KW_CONTINUE
%token KW_VAR
%token KW_RET
%token KW_NOT
%token KW_NULL
%token KW_START
%token KW_OR
%token KW_WHILE

%token <str> TK_IDENT
%token <str> TK_POSINT
%token <str> TK_POSREAL
%token <str> TK_STR

%token OP_EXPO
%token OP_EQUALITY
%token OP_INEQUALITY
%token OP_LE
%token OP_GE

%start input

%type <str> constant_decl
%type <str> variable_decl
%type <str> function_decl
%type <str> optional_decl
%type <str> start_decl

%type <str> in_fun_stmt

%%

input:  
  start_decl 
{ 
  if (yyerror_count == 0) {
    puts(c_prologue);
    printf("%s\n", $1);
  }  
}
| optional_decl start_decl
{ 
  if (yyerror_count == 0) {
    puts(c_prologue);
    printf("%s%s\n", $1, $2);
  }  
}
;

start_decl:
  KW_FUNCTION KW_START '(' ')' ':' KW_VOID '{' in_fun_stmt '}' { $$ = template("void main() {\n\t %s\n}", $8); }
;

optional_decl:
  constant_decl variable_decl function_decl
| variable_decl function_decl
| constant_decl function_decl
| function_decl
| constant_decl variable_decl
| constant_decl
| variable_decl
| %empty { $$ = template(""); }
;

constant_decl:
  %empty { $$ = template(""); }
;

variable_decl:
  %empty { $$ = template(""); }
;

function_decl:
  %empty { $$ = template(""); }
;

in_fun_stmt:
  %empty { $$ = template(""); }
;

%%
int main () {
  if ( yyparse() != 0 )
    printf("Rejected!\n");
}