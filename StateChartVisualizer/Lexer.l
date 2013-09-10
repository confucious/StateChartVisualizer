%{
#include "y.tab.h"
%}

%%
"->"                 { return TRANSITION;      }
"["                  { return TRANSITION_NAME_START;      }
"]"                  { return TRANSITION_NAME_END;      }
"("                  { return STATE_NAME_START;     }
")"                  { return STATE_NAME_END;     }
","                  { return COMMA;      }
"{"                  { return SUBSTATE_LIST_START;     }
"}"                  { return SUBSTATE_LIST_END;    }
";"                  { return SEMICOLON;        }
[_a-zA-Z0-9]+        { yylval = strdup(yytext);
    return IDENT;
}
[ \t\n\r]            /* skip whitespace */
.                    { //NSLog(@"lexer saw Unknown character [%c]\n", yytext[0]);
    return UNKNOWN;    }
%%

int yywrap(void){return 1;}
