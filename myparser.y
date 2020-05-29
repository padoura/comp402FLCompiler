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

%type <str> tk_posint_or_zero

%type <str> constant_decl
%type <str> boolean_value
%type <str> boolean_constant
%type <str> string_constant
%type <str> number_value
%type <str> number_constant
%type <str> constant_instance

%type <str> variable_decl
%type <str> uninitialized_variables
%type <str> number_instance
%type <str> string_instance
%type <str> boolean_instance
%type <str> uninitialized_boolean_variables
%type <str> uninitialized_string_variables
%type <str> uninitialized_number_variables
%type <str> boolean_decl_ending_part
%type <str> string_decl_ending_part
%type <str> number_decl_ending_part

%type <str> expression
%type <str> in_fun_body
%type <str> in_void_fun_body
%type <str> in_fun_stmts
%type <str> in_void_fun_stmts
%type <str> function_input


%type <str> function_decl
%type <str> start_decl





%%

// **************** Program syntax ****************

input:
  start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s\n", $1); } }
| constant_decl variable_decl function_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s %s %s\n\n%s\n", $1, $2, $3, $4); } }
| variable_decl function_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s %s\n\n%s\n", $1, $2, $3); } }
| constant_decl function_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s %s\n\n%s\n", $1, $2, $3); } }
| function_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s\n\n%s\n", $1, $2); } }
| constant_decl variable_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s %s\n\n%s\n", $1, $2, $3); } }
| constant_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s\n\n%s\n", $1, $2); } }
| variable_decl start_decl { if (yyerror_count == 0) { puts(c_prologue); printf("%s\n\n%s\n", $1, $2); } }
;

start_decl:
  KW_FUNCTION KW_START '(' ')' ':' KW_VOID '{' in_void_fun_body '}' { $$ = template("void main() {\n\t %s\n}", $8); }
;

// **************** Constant declarations ****************

constant_decl:
  KW_CONST constant_instance { $$ = template("const %s", $2); }
| constant_decl KW_CONST constant_instance { $$ = template("%s\nconst %s", $1, $3); }
;

constant_instance:
  number_constant ':' KW_NUMBER ';' { $$ = template("double %s;", $1); }
| string_constant ':' KW_STRING ';' { $$ = template("char* %s;", $1); }
| boolean_constant ':' KW_BOOL ';' { $$ = template("int %s;", $1); }
;

number_constant:
  TK_IDENT '=' number_value { $$ = template("%s = %s", $1, $3); }
| number_constant ',' TK_IDENT '=' number_value { $$ = template("%s, %s = %s", $1, $3, $5); }
;

number_value:
  tk_posint_or_zero { $$ = $1; }
| TK_POSREAL { $$ = $1; }
| '-' tk_posint_or_zero { $$ = template("-%s", $2); }
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
  KW_TRUE { $$ = "1"; }
| KW_FALSE { $$ = "0"; }
;

// **************** Variable declarations ****************

variable_decl:
  KW_VAR number_instance ':' KW_NUMBER ';' { $$ = template("double %s;", $2); }
| KW_VAR string_instance ':' KW_STRING ';' { $$ = template("char* %s;", $2); }
| KW_VAR boolean_instance ':' KW_BOOL ';' { $$ = template("int %s;", $2); }  
| variable_decl KW_VAR number_instance ':' KW_NUMBER ';' { $$ = template("%s\ndouble %s;", $1, $3); }
| variable_decl KW_VAR string_instance ':' KW_STRING ';' { $$ = template("%s\nchar* %s;", $1, $3); }
| variable_decl KW_VAR boolean_instance ':' KW_BOOL ';' { $$ = template("%s\nint %s;", $1, $3); }
| uninitialized_variables { $$ = $1; }
| variable_decl uninitialized_variables { $$ = template("%s\n%s", $1, $2); }
;

number_instance:
  number_constant { $$ = $1; }
| number_constant ',' number_instance { $$ = template("%s, %s", $1, $3); }
| TK_IDENT ',' number_instance { $$ = template("%s, %s", $1, $3); }
| TK_IDENT { $$ = $1; }
| TK_IDENT '[' TK_POSINT ']' ',' number_instance { $$ = template("%s[%s], %s", $1, $3, $6); }
| TK_IDENT '[' TK_POSINT ']' { $$ = template("%s[%s]", $1, $3); }
;

string_instance:
  string_constant { $$ = $1; }
| string_constant ',' string_instance { $$ = template("%s, %s", $1, $3); }
| TK_IDENT ',' string_instance { $$ = template("%s, %s", $1, $3); }
| TK_IDENT { $$ = $1; }
| TK_IDENT '[' TK_POSINT ']' ',' string_instance { $$ = template("%s[%s], %s", $1, $3, $6); }
| TK_IDENT '[' TK_POSINT ']' { $$ = template("%s[%s]", $1, $3); }
;

boolean_instance:
  boolean_constant { $$ = $1; }
| boolean_constant ',' boolean_instance { $$ = template("%s, %s", $1, $3); }
| TK_IDENT ',' boolean_instance { $$ = template("%s, %s", $1, $3); }
| TK_IDENT { $$ = $1; }
| TK_IDENT '[' TK_POSINT ']' ',' boolean_instance { $$ = template("%s[%s], %s", $1, $3, $6); }
| TK_IDENT '[' TK_POSINT ']' { $$ = template("%s[%s]", $1, $3); }
;

// Covers case with >1 uninitialized variables and 0 initialized, should stay at the bottom of this part

uninitialized_variables:
  uninitialized_number_variables { $$ = $1; }
| uninitialized_string_variables { $$ = $1; }
| uninitialized_boolean_variables { $$ = $1; }
;

uninitialized_number_variables:
  KW_VAR number_decl_ending_part { $$ = template("double %s;", $2); }
;

number_decl_ending_part:
  TK_IDENT ':' KW_NUMBER ';'  { $$ = $1; }
| TK_IDENT ',' number_decl_ending_part { $$ = template("%s, %s", $1, $3); }
| TK_IDENT '[' TK_POSINT ']' ':' KW_NUMBER ';'  { $$ = template("%s[%s]", $1, $3); }
| TK_IDENT '[' TK_POSINT ']' ',' number_decl_ending_part { $$ = template("%s[%s], %s", $1, $3, $6); }
;

uninitialized_string_variables:
  KW_VAR string_decl_ending_part { $$ = template("char* %s;", $2); }
;

string_decl_ending_part:
  TK_IDENT ':' KW_STRING ';'  { $$ = $1; }
| TK_IDENT ',' string_decl_ending_part { $$ = template("%s, %s", $1, $3); }
| TK_IDENT '[' TK_POSINT ']' ':' KW_STRING ';'  { $$ = template("%s[%s]", $1, $3); }
| TK_IDENT '[' TK_POSINT ']' ',' string_decl_ending_part { $$ = template("%s[%s], %s", $1, $3, $6); }
;

uninitialized_boolean_variables:
  KW_VAR boolean_decl_ending_part { $$ = template("int %s;", $2); }
;

boolean_decl_ending_part:
  TK_IDENT ':' KW_BOOL ';'  { $$ = $1; }
| TK_IDENT ',' boolean_decl_ending_part { $$ = template("%s, %s", $1, $3); }
| TK_IDENT '[' TK_POSINT ']' ':' KW_BOOL ';'  { $$ = template("%s[%s]", $1, $3); }
| TK_IDENT '[' TK_POSINT ']' ',' boolean_decl_ending_part { $$ = template("%s[%s], %s", $1, $3, $6); }
;

// **************** Function declarations ****************

function_decl:
  KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_NUMBER '{' in_fun_body '}' { $$ = template("double %s(%s) {\n\t %s\n}", $2, $4, $9); }
| KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_STRING '{' in_fun_body '}' { $$ = template("char* %s(%s) {\n\t %s\n}", $2, $4, $9); }
| KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_BOOL '{' in_fun_body '}' { $$ = template("int %s(%s) {\n\t %s\n}", $2, $4, $9); }
| KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_VOID '{' in_void_fun_body '}' { $$ = template("void %s(%s) {\n\t %s\n}", $2, $4, $9); }
| KW_FUNCTION TK_IDENT '(' function_input ')' '{' in_void_fun_body '}' { $$ = template("void %s(%s) {\n\t %s\n}", $2, $4, $7); }
| function_decl KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_NUMBER '{' in_fun_body '}' { $$ = template("%s\n\ndouble %s(%s) {\n\t %s\n}", $1, $3, $5, $10); }
| function_decl KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_STRING '{' in_fun_body '}' { $$ = template("%s\n\nchar* %s(%s) {\n\t %s\n}", $1, $3, $5, $10); }
| function_decl KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_BOOL '{' in_fun_body '}' { $$ = template("%s\n\nint %s(%s) {\n\t %s\n}", $1, $3, $5, $10); }
| function_decl KW_FUNCTION TK_IDENT '(' function_input ')' ':' KW_VOID '{' in_void_fun_body '}' { $$ = template("%s\n\nvoid %s(%s) {\n\t %s\n}", $1, $3, $5, $10); }
| function_decl KW_FUNCTION TK_IDENT '(' function_input ')' '{' in_void_fun_body '}' { $$ = template("%s\n\nvoid %s(%s) {\n\t %s\n}", $1, $3, $5, $8); }
;

in_void_fun_body:
  in_void_fun_body constant_decl { $$ = template("%s\n%s", $1, $2); }
| in_void_fun_body variable_decl { $$ = template("%s\n%s", $1, $2); }
| in_void_fun_stmts { $$ = $1; }
;

in_void_fun_stmts:
  KW_RET ';' { $$ = "\nreturn;"; }
| %empty { $$ = ""; }
;

in_fun_body:
  in_fun_body constant_decl  { $$ = template("%s\n%s", $1, $2); }
| in_fun_body variable_decl  { $$ = template("%s\n%s", $1, $2); }
| in_fun_stmts { $$ = $1; }
;

in_fun_stmts:
  KW_RET expression';' { $$ = "\nreturn;"; }
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

//
expression:
  %empty { $$ = ""; }
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