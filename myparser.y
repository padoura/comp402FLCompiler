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
%type <str> boolean_value
%type <str> boolean_constant
%type <str> string_constant
%type <str> number_value
%type <str> number_constant
%type <str> constant_instance

%type <str> variable_decl
%type <str> function_decl
%type <str> optional_decl
%type <str> start_decl

%type <str> in_fun_stmt




%%

// Program syntax

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
    printf("%s\n%s\n", $1, $2);
  }  
}
;

start_decl:
  KW_FUNCTION KW_START '(' ')' ':' KW_VOID '{' in_fun_stmt '}' { $$ = template("void main() {\n\t %s\n}", $8); }
;

optional_decl:
  constant_decl variable_decl function_decl { $$ = template("%s %s %s", $1, $2, $3); }
| variable_decl function_decl { $$ = template("%s %s", $1, $2); }
| constant_decl function_decl { $$ = template("%s %s", $1, $2); }
| function_decl { $$ = template("%s", $1); }
| constant_decl variable_decl { $$ = template("%s %s", $1, $2); }
| constant_decl { $$ = template("%s", $1); }
| variable_decl { $$ = template("%s", $1); }
| %empty { $$ = template(""); }
;

// Constant declarations

constant_decl:
  KW_CONST constant_instance { $$ = template("const %s", $2); }
| constant_decl KW_CONST constant_instance { $$ = template("%s\nconst %s", $1, $3); }
;

constant_instance:
  number_constant ':' KW_NUMBER ';' { $$ = template("double %s;", $1); }
| string_constant ':' KW_STRING ';' { $$ = template("string %s;", $1); }
| boolean_constant ':' KW_BOOL ';' { $$ = template("int %s;", $1); }
;

number_constant:
  TK_IDENT '=' number_value { $$ = template("%s = %s", $1, $3); }
| number_constant ',' TK_IDENT '=' number_value { $$ = template("%s, %s = %s", $1, $3, $5); }
;

number_value:
  TK_POSINT { $$ = template("%s", $1); }
| TK_POSREAL { $$ = template("%s", $1); }
| '-' TK_POSINT { $$ = template("-%s", $2); }
| '-' TK_POSREAL { $$ = template("-%s", $2); }
;

string_constant:
  TK_IDENT '=' TK_STR { $$ = template("%s = %s", $1, $3); }
| string_constant ',' TK_IDENT '=' TK_STR { $$ = template("%s, %s = %s", $1, $3, $5); }
;

boolean_constant:
  TK_IDENT '=' boolean_value { $$ = template("%s = %s", $1, $3); }
| boolean_constant ',' TK_IDENT '=' boolean_value { $$ = template("%s, %s = %s", $1, $3, $5); }
;

boolean_value:
  KW_TRUE { $$ = template("1"); }
| KW_FALSE { $$ = template("0"); }
;

//

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
  yyparse();
}