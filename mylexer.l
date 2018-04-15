%{
  #define KW_AND 258
  #define KW_ARRAY 259
  #define KW_BOOL 260
  #define KW_CHAR 261
  #define KW_BEGIN 262
  #define KW_DIV 263
  #define KW_DO 264
  #define KW_ELSE 265
  #define KW_FOR 266
  #define KW_END 267
  #define KW_FUN 268
  #define KW_GOTO 269
  #define KW_IF 270
  #define KW_INT 271
  #define KW_VAR 272
  #define KW_MOD 273
  #define KW_NOT 274
  #define KW_OF 275
  #define KW_OR 276
  #define KW_WHILE 277
  #define KW_PROC 278
  #define KW_PROG 279
  #define KW_REAL 280
  #define KW_REP 281
  #define KW_TO 282
  #define KW_RES 283
  #define KW_RET 284
  #define KW_THEN 285
  #define KW_UNTIL 286
  #define KW_DOWNTO 287

  #define TK_IDENT 288
  #define TK_POSINT 289
  #define TK_POSREAL 290
  #define TK_BOOL 291
  #define TK_STR 292

  #define OP_CAST 294
  #define OP_ASSGN 295
  #define OP_LG 296
  #define OP_LE 297
  #define OP_GE 298

  #define LINE_COMMENT 299

  #include <math.h>
  int lineNum = 1;
%}

ID [a-zA-Z][0-9a-zA-Z_]*
DIGIT   [0-9]
NONZERO_DIGIT [1-9]
NUMBER  {DIGIT}{DIGIT}*
INTEGER  ({NONZERO_DIGIT}{DIGIT}*)|0
DECIMAL {INTEGER}\.{NUMBER}
REAL    {DECIMAL}([eE][+-]?{INTEGER})?
CAST    \((integer)|(boolean)|(char)|(real)\)

%x str
%x comment
%x macro

%%

and           return KW_AND;
array         return KW_ARRAY;
boolean       return KW_BOOL;
char          return KW_CHAR;
begin         return KW_BEGIN;
div           return KW_DIV;
do            return KW_DO;
else          return KW_ELSE;
for           return KW_FOR;
end           return KW_END;
function      return KW_FUN;
goto          return KW_GOTO;
if            return KW_IF;
integer       return KW_INT;
var           return KW_VAR;
mod           return KW_MOD;
not           return KW_NOT;
of            return KW_OF;
or            return KW_OR;
while         return KW_WHILE;
procedure     return KW_PROC;
program       return KW_PROG;
real          return KW_REAL;
repeat        return KW_REP;
to            return KW_TO;
result        return KW_RES;
return        return KW_RET;
then          return KW_THEN;
until         return KW_UNTIL;
downto        return KW_DOWNTO;

"+"           return '+';
"-"           return '-';
"*"						return '*';
"/"						return '/';
"="           return '=';
"<>"          return OP_LG;
"<"           return '<';
"<="          return OP_LE;
">"           return '>';
">="          return OP_GE;
"&&"          return KW_AND;
"||"          return KW_OR;
"!"           return KW_NOT;
":="          return OP_ASSGN;
"."           return '.';
":"           return ':';
","           return ',';
"["           return  '[';
"]"           return ']';
"("           return '(';
")"           return ')';
";"           return ';';

"//"[^\n]*    return LINE_COMMENT;/* eat line comments */
[ \r\t]		   /* skip whitespace */
\n 			      ++lineNum;
<<EOF>> 	   return EOF;


%%

/* TODO Print token type name for each token int.*/
char* tk_type(int token)
{
  switch(token){
    case LINE_COMMENT :
      return "LINE COMMENT";
      break;
  }
}


int main ()
{
   int token;
   while ( (token = yylex()) != EOF )
      printf("Line %d Token %s: %s\n", lineNum, tk_type(token), yytext);
}
