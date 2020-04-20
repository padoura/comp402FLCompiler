%{
  #define KW_AND 258
  #define KW_NUMBER 259
  #define KW_BOOL 260
  #define KW_STRING 261
  #define KW_VOID 262
  #define KW_TRUE 263
  #define KW_FALSE 264
  #define KW_ELSE 265
  #define KW_FOR 266
  #define KW_CONST 267
  #define KW_FUNCTION 268
  #define KW_BREAK 269
  #define KW_IF 270
  #define KW_CONTINUE 271
  #define KW_VAR 272
  #define KW_RET 284
  #define KW_NOT 274
  #define KW_NULL 275
  #define KW_OR 276
  #define KW_WHILE 277

  #define TK_IDENT 288
  #define TK_POSINT 289
  #define TK_POSREAL 290
  #define TK_STR 291

  #define OP_EXPO 293
  #define OP_EQUALITY 294
  #define OP_INEQUALITY 295
  #define OP_LE 296
  #define OP_GE 297

  #include <string.h>
  #include <assert.h>
  int lineNum = 1;


  /*
  	A primitive macro facility:
  	just one macro is allowed to be defined!
  */
  #define MAXMACRO 32
  char* mactable[MAXMACRO][2];
  int mactable_size = 0;

  /* Return 1 on success, 0 on failure (macro table full) */
  int set_macro(char* name, char* def);

  /* Return def for macro, or NULL if no such macro is defined. */
  char* get_macro(char* name);

%}

ID [a-zA-Z][0-9a-zA-Z_]*
DIGIT   [0-9]
NONZERO_DIGIT [1-9]
DECIMAL_PART  {DIGIT}{DIGIT}*
POSITIVE_INTEGER  ({NONZERO_DIGIT}{DIGIT}*)|0
DECIMAL {POSITIVE_INTEGER}\.{DECIMAL_PART}
REAL    {DECIMAL}([eE][+-]?{POSITIVE_INTEGER})?
/* TODO Line below will be removed*/
STRING  [\"\'][^\"\n]*[\"\']

/* TODO Fix handling of escape characters based on manual*/
/* TODO Fix double quoted strings*/
%x str_dquote 
/* TODO Fix single quoted strings*/
%x str_squote
%x comment
%x macro

%%

@defmacro[ \r\t]+       BEGIN(macro);
<macro>{ID}             {
							/* Store macro name */
							char* name = strdup(yytext);
							char* def = NULL;
							size_t deflen = 0;
							char c;

							FILE* deff = open_memstream(&def, &deflen);

							while((c=input())!='\n')
							   fputc(c, deff);
							fclose(deff);

							if(!set_macro(name, def))
								printf("\nlexer error: failed to define macro '%s'\n\n", name);
							BEGIN(INITIAL);
              lineNum++;
						};

"/*"					BEGIN(comment);
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


{STRING}      return TK_STR;
"//"[^\n]*    /* eat line comments */
[ \r\t]		   /* skip whitespace */
\n 			      ++lineNum;

{POSITIVE_INTEGER}   return TK_POSINT;
{REAL}      return TK_POSREAL;

{ID}  			{
						   char* def = get_macro(yytext);
						   if(def==NULL) {
						   		return TK_IDENT;
						   }
						   for(int i=strlen(def); i>0; i--) {
						   	  unput(def[i-1]);
						   }
						}

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

int set_macro(char* name, char* def)
{
	/* Check to see if macro already defined, and redefine it. */
	int i;
	for(i=0; i<mactable_size; i++) {
		if(strcmp(mactable[i][0], name)==0) {
			/* found ! */
			free(name);
			free(mactable[i][1]);
			mactable[i][1] = def;
			break;
		}
	}
	if(i<mactable_size)
		return 1;
	else if(mactable_size < MAXMACRO) {
		/* new entry */
		assert(i==mactable_size);
		mactable[i][0] = name;
		mactable[i][1] = def;
		mactable_size++;
		return 1;
	}
	else
		return 0;
}

char* get_macro(char* name)
{
	for(int i=0;i<mactable_size; i++) {
		if(strcmp(mactable[i][0], name)==0)
			return mactable[i][1];
	}
	return NULL;
}

int main ()
{
   int token;
   while ( (token = yylex()) != EOF )
      printf("Line %d Token %s: %s\n", lineNum, tk_type(token), yytext);
}
