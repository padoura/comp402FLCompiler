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

%define parse.error verbose

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

%start input

%type <str> tk_posint_or_zero

%type <str> constant_decl
%type <str> constant_instance
%type <str> constant

%type <str> variable_decl
%type <str> variable_instance

%type <str> in_fun_body
%type <str> function_input

%type <str> stmt
%type <str> in_loop_stmt
%type <str> block_stmt
%type <str> loop_block_stmt
%type <str> stmt_assignment
%type <str> stmt_for
%type <str> stmt_while
%type <str> stmt_if
%type <str> stmt_fun_call
%type <str> input_fun_call_exprs
%type <str> in_block_stmts
%type <str> in_loop_block_stmts
%type <str> in_loop_stmt_if

%type <str> expr

%type <str> function_decl
%type <str> start_decl

%precedence ')'
%precedence KW_ELSE



%left KW_OR
%left KW_AND
%left OP_EQUALITY OP_INEQUALITY OP_LE '<'
%left '-' '+'
%left '*' '/' '%'
%right OP_EXPO
%right KW_NOT

%%

// **************** Program syntax ****************

input:
  start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s\n", $1); } }
| constant_decl variable_decl function_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s\n%s\n%s\n\n%s\n", $1, $2, $3, $4); } }
| variable_decl function_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s\n%s\n\n%s\n", $1, $2, $3); } }
| constant_decl function_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s\n%s\n\n%s\n", $1, $2, $3); } }
| function_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s\n\n%s\n", $1, $2); } }
| constant_decl variable_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s %s\n\n%s\n", $1, $2, $3); } }
| constant_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s\n\n%s\n", $1, $2); } }
| variable_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s\n\n%s\n", $1, $2); } }
;

start_decl:
  KW_FUNCTION KW_START '(' ')' ':' KW_VOID '{' in_fun_body '}' { $$ = template("void main() {\n%s\n}", $8); }
;

// **************** Constant declarations ****************

constant_decl:
  KW_CONST constant_instance { $$ = template("const %s\n", $2); }
| constant_decl KW_CONST constant_instance { $$ = template("%sconst %s\n", $1, $3); }
;

constant_instance:
  constant ':' KW_NUMBER ';' { $$ = template("double %s;", $1); }
| constant ':' KW_STRING ';' { $$ = template("char* %s;", $1); }
| constant ':' KW_BOOL ';' { $$ = template("int %s;", $1); }
;

constant:
  stmt_assignment { $$ = template("%s", $1); }
| constant ',' stmt_assignment { $$ = template("%s, %s", $1, $3); }
;

// **************** Variable declarations ****************

variable_decl:
  KW_VAR variable_instance ':' KW_NUMBER ';' { $$ = template("double %s;\n", $2); }
| KW_VAR variable_instance ':' KW_STRING ';' { $$ = template("char* %s;\n", $2); }
| KW_VAR variable_instance ':' KW_BOOL ';' { $$ = template("int %s;\n", $2); }  
| variable_decl KW_VAR variable_instance ':' KW_NUMBER ';' { $$ = template("%s\ndouble %s;\n", $1, $3); }
| variable_decl KW_VAR variable_instance ':' KW_STRING ';' { $$ = template("%s\nchar* %s;\n", $1, $3); }
| variable_decl KW_VAR variable_instance ':' KW_BOOL ';' { $$ = template("%s\nint %s;\n", $1, $3); }
;

variable_instance:
  constant { $$ = template("%s", $1); }
| constant ',' variable_instance { $$ = template("%s, %s", $1, $3); }
| TK_IDENT ',' variable_instance { $$ = template("%s, %s", $1, $3); }
| TK_IDENT { $$ = $1; }
| TK_IDENT '[' TK_POSINT ']' ',' variable_instance { $$ = template("%s[%s], %s", $1, $3, $6); }
| TK_IDENT '[' TK_POSINT ']' { $$ = template("%s[%s]", $1, $3); }
;

// **************** Function declarations ****************

function_decl:
  KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_NUMBER '{' in_fun_body '}' { $$ = template("double %s(%s) {\n%s\n}", $2, $4, $9); }
| KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_STRING '{' in_fun_body '}' { $$ = template("char* %s(%s) {\n%s\n}", $2, $4, $9); }
| KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_BOOL '{' in_fun_body '}' { $$ = template("int %s(%s) {\n%s\n}", $2, $4, $9); }
| KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_VOID '{' in_fun_body '}' { $$ = template("void %s(%s) {\n%s\n}", $2, $4, $9); }
| KW_FUNCTION TK_IDENT '(' function_input ')' '{' in_fun_body '}' { $$ = template("void %s(%s) {\n%s\n}", $2, $4, $7); }
| function_decl KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_NUMBER '{' in_fun_body '}' { $$ = template("%s\n\ndouble %s(%s) {\n%s\n}", $1, $3, $5, $10); }
| function_decl KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_STRING '{' in_fun_body '}' { $$ = template("%s\n\nchar* %s(%s) {\n%s\n}", $1, $3, $5, $10); }
| function_decl KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_BOOL '{' in_fun_body '}' { $$ = template("%s\n\nint %s(%s) {\n%s\n}", $1, $3, $5, $10); }
| function_decl KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_VOID '{' in_fun_body '}' { $$ = template("%s\n\nvoid %s(%s) {\n%s\n}", $1, $3, $5, $10); }
| function_decl KW_FUNCTION TK_IDENT '(' function_input ')' '{' in_fun_body '}' { $$ = template("%s\n\nvoid %s(%s) {\n%s\n}", $1, $3, $5, $8); }
;

in_fun_body:
  constant_decl in_fun_body { $$ = template("\t%s\n%s", $1, $2); }
| variable_decl in_fun_body { $$ = template("\t%s\n%s", $1, $2); }
| in_block_stmts { $$ = $1; }
;

function_input:
  TK_IDENT ':' KW_NUMBER { $$ = template("double %s", $1); }
| TK_IDENT ':' KW_BOOL { $$ = template("int %s", $1); }
| TK_IDENT ':' KW_STRING { $$ = template("char* %s", $1); }
| function_input ',' TK_IDENT ':' KW_NUMBER { $$ = template("%s, double %s", $1, $3); }
| function_input ',' TK_IDENT ':' KW_BOOL { $$ = template("%s, int %s", $1, $3); }
| function_input ',' TK_IDENT ':' KW_STRING { $$ = template("%s, char* %s", $1, $3); }
| TK_IDENT '[' ']' ':' KW_NUMBER { $$ = template("double* %s", $1); }
| TK_IDENT '[' ']' ':' KW_BOOL { $$ = template("int* %s", $1); }
| TK_IDENT '[' ']' ':' KW_STRING { $$ = template("char** %s", $1); }
| function_input ',' TK_IDENT '[' ']' ':' KW_NUMBER { $$ = template("%s, double* %s", $1, $3); }
| function_input ',' TK_IDENT '[' ']' ':' KW_BOOL { $$ = template("%s, int* %s", $1, $3); }
| function_input ',' TK_IDENT '[' ']' ':' KW_STRING { $$ = template("%s, char** %s", $1, $3); }
| %empty { $$ = ""; }
;

// **************** Statements ****************

stmt:
  stmt_assignment ';' { $$ = template("%s;", $1); }
| stmt_if { $$ = $1; }
| stmt_for { $$ = $1; }
| stmt_while { $$ = $1; }
| stmt_fun_call ';' { $$ = template("%s;", $1); }
| KW_RET ';' { $$ = "\n\treturn;"; }
| KW_RET expr ';' { $$ = template("\n\treturn %s;", $2); }
;

in_loop_stmt:
  stmt { $$ = template("\t%s", $1); }
| in_loop_stmt_if { $$ = $1; }
| KW_BREAK ';' { $$ = "break;"; }
| KW_CONTINUE ';' { $$ = "continue;"; }
;

in_block_stmts:
  in_block_stmts stmt { $$ = template("%s\n\t%s", $1, $2); }
| %empty { $$ = ""; }
;

block_stmt:
  '{' in_block_stmts '}' ';' { $$ = template("{\n%s\n\t}", $2); }
| stmt { $$ = template("%s", $1); }
;

in_loop_block_stmts:
  in_loop_block_stmts in_loop_stmt { $$ = template("%s\n\t%s", $1, $2); }
| %empty { $$ = ""; }
;

loop_block_stmt:
  '{' in_loop_block_stmts '}' ';' { $$ = template("{\n%s\n\t}", $2); }
| in_loop_stmt { $$ = template("%s", $1); }
;

stmt_assignment:
  TK_IDENT '=' expr { $$ = template("%s = %s", $1, $3); }
;

stmt_if:
  KW_IF '(' expr ')' block_stmt KW_ELSE block_stmt { $$ = template("if(%s)\n\t\t%s\n\telse %s", $3, $5, $7); }
| KW_IF '(' expr ')' block_stmt { $$ = template("if(%s)\n\t\t%s", $3, $5); }
;

in_loop_stmt_if:
  KW_IF '(' expr ')' loop_block_stmt KW_ELSE loop_block_stmt { $$ = template("if(%s)\n\t\t%s\n\telse %s", $3, $5, $7); }
| KW_IF '(' expr ')' loop_block_stmt { $$ = template("if(%s)\n\t\t%s", $3, $5); }
;

stmt_for:
  KW_FOR '(' stmt_assignment ';' expr ';' stmt_assignment ')' loop_block_stmt { $$ = template("for(%s;%s;%s)%s", $3, $5, $7, $9); }
;

stmt_while:
  KW_WHILE '(' expr ')' loop_block_stmt { $$ = template("while(%s)%s", $3, $5); }
;

stmt_fun_call:
  TK_IDENT '(' input_fun_call_exprs ')' { $$ = template("%s(%s)", $1, $3); }
| TK_IDENT '(' ')' { $$ = template("%s()", $1); }
;

input_fun_call_exprs:
  input_fun_call_exprs ',' expr { $$ = template("%s, %s", $1, $3); }
| expr { $$ = $1; }
;

// **************** Expressions ****************
expr:
  TK_STR { $$ = $1; }
| KW_TRUE { $$ = "1"; }
| KW_FALSE { $$ = "0"; }
| TK_IDENT { $$ = $1; }
| TK_IDENT '[' expr ']' { $$ = template("%s[(int) (%s)]", $1, $3); }
| stmt_fun_call { $$ = $1; }
| expr OP_EQUALITY expr { $$ = template("(%s==%s)", $1, $3); }
| expr OP_LE expr { $$ = template("(%s<=%s)", $1, $3); }
| expr '<' expr { $$ = template("(%s<%s)", $1, $3); }
| expr OP_INEQUALITY expr { $$ = template("(%s!=%s)", $1, $3); }
| '(' expr ')' { $$ = template("(%s)", $2); }
| expr KW_AND expr { $$ = template("(%s && %s)", $1, $3); }
| expr KW_OR expr { $$ = template("(%s || %s)", $1, $3); }
| KW_NOT expr { $$ = template("!(%s)", $2); }
| tk_posint_or_zero { $$ = $1; }
| TK_POSREAL { $$ = $1; }
| expr '+' expr { $$ = template("%s+%s", $1, $3); }
| expr '-' expr { $$ = template("%s-%s", $1, $3); }
| expr '/' expr { $$ = template("%s/%s", $1, $3); }
| expr '%' expr { $$ = template("%s\%%s", $1, $3); }
| expr '*' expr { $$ = template("%s*%s", $1, $3); }
| expr OP_EXPO expr { $$ = template("pow(%s, %s)", $1, $3); }
| '-' expr { $$ = template("(-%s)", $2); }
| '+' expr { $$ = template("(+%s)", $2); }
;

// **************** Misc ****************

tk_posint_or_zero:
  TK_POSINT { $$ = $1; }
| '0' { $$ = "0"; }
;
  


%%
int main () {
  yyparse();
}