%{

#define YYSTYPE char*

void yyerror(const char *str)
{
   // NSLog(@"yacc error: %s", str);
}

int yywrap()
{
    return 1;
}

%}

%token TRANSITION TRANSITION_NAME_START TRANSITION_NAME_END STATE_NAME_START STATE_NAME_END SUBSTATE_LIST_START SUBSTATE_LIST_END COMMA SEMICOLON IDENT UNKNOWN
%%

statements:
    /* empty */
    | statements statement
;

statement:
    state substateList SEMICOLON
    | transitionChain
;

state:
    STATE_NAME_START IDENT STATE_NAME_END
;

transition:
    TRANSITION_NAME_START IDENT TRANSITION_NAME_END TRANSITION
    | TRANSITION
;

substateList:
    SUBSTATE_LIST_START substateEntries SUBSTATE_LIST_END
;

substateEntries:
    /* empty */
    | substateEntries COMMA state
    | state
;

transitionChain:
    transitionPrefix state SEMICOLON
;

transitionPrefix:
    transitionPrefix transitionPrefix
    | state transition
;
%%
