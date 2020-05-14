%{
  #include <string.h>
  #include "myparser.tab.h"
  int lineNum = 1;

  char* tk_type(int token);

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
REAL    {DECIMAL}([eE][+-]?{POSITIVE_INTEGER})?
COMMON_CHAR [ a-zA-Z\-\+\*/:_$!#@&~\^\(\),\.]|DIGIT

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
<str_dquote>"\""                { *s++ = '"'; strLen++; *s = 0; BEGIN(INITIAL); return TK_STR; }
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
<str_squote>"'"                 { *s++ = '"'; strLen++; *s = 0; BEGIN(INITIAL); return TK_STR; }
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

{POSITIVE_INTEGER}   return TK_POSINT;
{REAL}      return TK_POSREAL;

{ID}          return TK_IDENT;

.           { printf("\nLexical error: Unrecognized token %s in line %d\n\n", yytext, lineNum); return EOF;}
<<EOF>> 	   return EOF;

%%

char* tk_type(int token)
{
  switch(token){
    case '+' :
      return "OP_PLUS";
      break;
    case '-' :
      return "OP_MINUS";
      break;
    case '*' :
      return "OP_MULTIPLY";
      break;
    case OP_EXPO :
      return "OP_EXPONENTIATION";
      break;
    case '/' :
      return "OP_DIVIDE";
      break;
    case OP_EQUALITY :
      return "OP_EQUALITY";
      break;
    case OP_INEQUALITY :
      return "OP_INEQUALITY";
      break;
    case '<' :
      return "OP_LESS";
      break;
    case OP_LE :
      return "OP_LESS_EQUAL";
      break;
    case KW_AND:
      return "LOGICAL_AND";
      break;
    case KW_OR:
      return "LOGICAL_OR";
      break;
    case KW_NOT:
      return "LOGICAL_NOT";
      break;
    case '=':
      return "ASSIGNMENT";
      break;
    case ':' :
      return "COLON";
      break;
    case ',' :
      return "COMMA";
      break;
    case '[' :
      return "LEFT_BRACKET";
      break;
    case ']' :
      return "RIGHT_BRACKET";
      break;
    case '{' :
      return "LEFT_CURLY_BRACKET";
      break;
    case '}' :
      return "RIGHT_CURLY_BRACKET";
      break;
    case '(' :
      return "LEFT_PARENTHESIS";
      break;
    case ')' :
      return "RIGHT_PARENTHESIS";
      break;
    case ';' :
      return "SEMICOLON";
      break;
    case KW_BOOL :
      return "KW_BOOLEAN";
      break;
    case KW_ELSE :
      return "KW_ELSE";
      break;
    case KW_FOR :
      return "KW_FOR";
      break;
    case KW_FUNCTION :
      return "KW_FUNCTION";
      break;
    case KW_IF :
      return "KW_IF";
      break;
    case KW_VAR :
      return "KW_VAR";
      break;
    case '%' :
      return "OP_MODULO";
      break;
    case KW_WHILE :
      return "KW_WHILE";
      break;
    case KW_RET :
      return "KW_RETURN";
      break;
    case TK_POSINT :
      return "POSITIVE_INTEGER";
      break;
    case TK_POSREAL :
      return "REAL";
      break;
    case TK_IDENT :
      return "IDENTIFIER";
      break;
    case TK_STR :
      return "STRING";
      break;
    case KW_NUMBER :
      return "KW_NUMBER";
      break;
    case KW_CONST :
      return "KW_CONST";
      break;
    case KW_VOID :
      return "KW_VOID";
      break;
    case KW_NULL :
      return "KW_NULL";
      break;
    case KW_FALSE :
      return "KW_FALSE";
      break;
    case KW_TRUE :
      return "KW_TRUE";
      break;
    case KW_STRING :
      return "KW_STRING";
      break;
    default : // lexer should never reach here
      return "UNCATEGORIZED_TOKEN";
  }
}

void realloc_buf(){
  if (strLen==0){
    buf = realloc(NULL, sizeof(char)*initSize);
  }else if(strLen==initSize){
    buf = realloc(buf, sizeof(char)*(initSize+=16));
  }
}

int main ()
{
   int token;
   while ( (token = yylex()) != EOF ) {
     if ( token == TK_STR ){
       printf("Line %d Token %s: %s\n", lineNum, tk_type(token), buf);
     }else{
       printf("Line %d Token %s: %s\n", lineNum, tk_type(token), yytext);
     }
   }
}
