%{
  #include <stdio.h>
  #include <string.h>  
  #include "cgen.h"
  #include  "myparser.tab.h"
  int lineNum = 1;

  // char* tk_type(int token);

  /* takes care of string literals, dynamic length allocation */
  int initSize = 100;
  int strLen;
  char *buf;
  char *s;
  void realloc_buf();

%}

ID [a-zA-Z][0-9a-zA-Z_]*
DIGIT   [0-9]
NONZERO_DIGIT [1-9]
DECIMAL_PART  {DIGIT}{DIGIT}*
POSITIVE_INTEGER  ({NONZERO_DIGIT}{DIGIT}*)|0
DECIMAL {POSITIVE_INTEGER}\.{DECIMAL_PART}
REAL    ({DECIMAL}|{POSITIVE_INTEGER})([eE][+-]?{POSITIVE_INTEGER})?
COMMON_CHAR ([ a-zA-Z\-\+\*/:_$!#@&~\^\(\),\.])|{DIGIT}

%x str_dquote
%x str_squote
%x comment

%%

"\""                            { BEGIN(str_dquote); realloc_buf(); s = buf; *s++ = '"'; strLen++; }
<str_dquote>"\\n"               { *s++ = '\\'; *s++ = 'n'; strLen++; realloc_buf(); } /* eats newline */
<str_dquote>"\\\""              { *s++ = '"'; strLen++; realloc_buf(); }  /* eats escaped double quote */
<str_dquote>"\\\'"              { *s++ = '\''; strLen++; realloc_buf(); }  /* eats escaped single quote */
<str_dquote>"\\t"               { *s++ = '\\'; *s++ = 't'; strLen++; realloc_buf(); } /* eats tab */
<str_dquote>"\\r"               { *s++ = '\\'; *s++ = 'r'; strLen++; realloc_buf(); } /* eats carriage return */
<str_dquote>"\\\\"              { *s++ = '\\'; *s++ = '\\'; strLen++; realloc_buf(); }  /* eats escaped backslash */
<str_dquote>{COMMON_CHAR}       { *s++ = *yytext; strLen++; realloc_buf(); }        /* eats defined common characters */
<str_dquote>"'"                 { printf("\nLexical error: Unescaped single quote in line %d\n\n", lineNum); return EOF; }
<str_dquote>"\\"                { printf("\nLexical error: Unescaped backslash in line %d\n\n", lineNum); return EOF; }
<str_dquote>"\""                { *s++ = '"'; strLen++; *s = 0; yylval.str = strdup(buf); BEGIN(INITIAL); return TK_STR; }
<str_dquote>.                   { printf("\nLexical error: Unexpected character in line %d\n\n", lineNum); return EOF; }

"\'"                            { BEGIN(str_squote); realloc_buf(); s = buf; *s++ = '\''; strLen++; }
<str_squote>"\\n"               { *s++ = '\\'; *s++ = 'n'; strLen++; realloc_buf(); } /* eats newline */
<str_squote>"\\\""              { *s++ = '"'; strLen++; realloc_buf(); }  /* eats escaped double quote */
<str_squote>"\\\'"              { *s++ = '\''; strLen++; realloc_buf(); }  /* eats escaped single quote */
<str_squote>"\\t"               { *s++ = '\\'; *s++ = 't'; strLen++; realloc_buf(); } /* eats tab */
<str_squote>"\\r"               { *s++ = '\\'; *s++ = 'r'; strLen++; realloc_buf(); } /* eats carriage return */
<str_squote>"\\\\"              { *s++ = '\\'; *s++ = '\\'; strLen++; realloc_buf(); }  /* eats escaped backslash */
<str_squote>{COMMON_CHAR}       { *s++ = *yytext; strLen++; realloc_buf(); }        /* eats defined common characters */
<str_squote>"\""                { printf("\nLexical error: Unescaped double quote in line %d\n\n", lineNum); return EOF; }
<str_squote>"\\"                { printf("\nLexical error: Unescaped backslash in line %d\n\n", lineNum); return EOF; }
<str_squote>"'"                 { *s++ = '\''; strLen++; *s = 0; yylval.str = strdup(buf); BEGIN(INITIAL); return TK_STR; }
<str_squote>.                   { printf("\nLexical error: Unexpected character in line %d\n\n", lineNum); return EOF; }

"/*"					          BEGIN(comment);
<comment>[^*\n]*        /* eat anything that's not a '*' */
<comment>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<comment>\n             ++lineNum;
<comment>"*"+"/"        BEGIN(INITIAL);


number        return KW_NUMBER;
string        return KW_STRING;
void          return KW_VOID;
true          return KW_TRUE;
false         return KW_FALSE;
const         return KW_CONST;
break         return KW_BREAK;
continue      return KW_CONTINUE;
null          return KW_NULL;
start         return KW_START;

boolean       return KW_BOOL;
and           return KW_AND;
else          return KW_ELSE;
for           return KW_FOR;
function      return KW_FUNCTION;
if            return KW_IF;
var           return KW_VAR;
not           return KW_NOT;
or            return KW_OR;
while         return KW_WHILE;
return        return KW_RET;

"+"           return '+';
"-"           return '-';
"*"						return '*';
"**"				  return OP_EXPO;
"/"						return '/';
"=="          return OP_EQUALITY;
"!="          return OP_INEQUALITY;
"<"           return '<';
"<="          return OP_LE;
"!"           return KW_NOT;
"="           return '=';
"%"           return '%';
":"           return ':';
","           return ',';
"["           return '[';
"]"           return ']';
"("           return '(';
")"           return ')';
";"           return ';';
"{"           return '{';
"}"           return '}';


"//"[^\n]*    /* eat line comments */
[ \r\t]		   /* skip whitespace */
\n 			      ++lineNum;

{POSITIVE_INTEGER}   { yylval.str = strdup(yytext); return TK_POSINT; }
{REAL}      { yylval.str = strdup(yytext); return TK_POSREAL; }

{ID}          { yylval.str = strdup(yytext); return TK_IDENT; }

<<EOF>> 	   return EOF;
.           { printf("\nLexical error: Unrecognized token %s in line %d\n\n", yytext, lineNum); return EOF;}

%%

void realloc_buf(){
  if (strLen==0){
    buf = realloc(NULL, sizeof(char)*initSize);
  }else if(strLen==initSize){
    buf = realloc(buf, sizeof(char)*(initSize+=16));
  }
}
