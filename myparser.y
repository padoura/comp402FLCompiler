%{
    int yylex(void);

    void yyerror(const char* s);
%}

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
%token KW_OR
%token KW_WHILE

%token TK_IDENT
%token TK_POSINT
%token TK_POSREAL
%token TK_STR

%token OP_EXPO
%token OP_EQUALITY
%token OP_INEQUALITY
%token OP_LE
%token OP_GE

%%
input: %empty

%%

void yyerror(const char* s){

};