grammar Hello;
prog:   (
            comment_line*
            programName
            comment_line*
            declarations*
            comment_line*
            funcDeclarations*
            comment_line*
            BEGIN
            comment_line*
            expressions*
            comment_line*
            END
            comment_line*
        )*  EOF;

// PARSER RULES
programName:
    PROGRAM STRING WS*;

// VAR DECLARATIONS RULEs
declarations:
    uniqueLineMultiDeclarations;

uniqueLineVar:
    VAR 
        (VAR_NAME (COMMA VAR_NAME)* COLON WS* 
            (TYPE_INT | TYPE_FLOAT | TYPE_STRING | TYPE_BOOL)
    *)+;

uniqueLineMultiDeclarations:
    VAR (uniqueLineDeclaration COLON (TYPE_INT | TYPE_FLOAT | TYPE_STRING | TYPE_BOOL))+;
uniqueLineDeclaration: (VAR_NAME | (VAR_NAME COMMA uniqueLineDeclaration)*);
funcVarDeclaration:
    VAR_NAME COLON (TYPE_INT | TYPE_FLOAT | TYPE_STRING | TYPE_BOOL)
        (SEMI_COLON WS* VAR_NAME COLON (TYPE_INT | TYPE_FLOAT | TYPE_STRING | TYPE_BOOL))*;

// FUNC DECLARATIONS RULE
funcDeclarations:
    funcInt
    | funcBool
    | funcFloat
    | funcString
    | funcVoid;

// EXPRESSIONS RULE
expressions:
    printer
    | reader
    | constOperations
    | constFunc
    | constNumeric
    | constString
    | constBool
    | ifStatement
    | whileStatement
    | funcCall;

comment_line: WS* COMMENT+;

// PRINTER RULEs
printer: printSingleValue | printMultipleValues;
printSingleValue:
    PRINT WS* OPEN_PARENTHESIS (STRING | INT | FLOAT | BOOL | funcCall) CLOSE_PARENTHESIS WS*;
printMultipleValues:
    PRINT OPEN_PARENTHESIS ((STRING | VAR_NAME) (COMMA (STRING | VAR_NAME))*)+ CLOSE_PARENTHESIS;

// READER RULES
reader: readSingleValue;
readSingleValue: READ WS* OPEN_PARENTHESIS (VAR_NAME) CLOSE_PARENTHESIS WS*;

// STILL MISSING OPERATION WITH + SYMBOL
constNumeric: VAR_NAME ASSIGNMENT (INT | FLOAT) WS*;
constString: VAR_NAME ASSIGNMENT STRING WS*;
constBool: VAR_NAME ASSIGNMENT BOOL WS*;
constOperations: VAR_NAME ASSIGNMENT VAR_NAME ((arithmeticOperator | relationalOperator) (VAR_NAME | (INT | FLOAT)))*;
constFunc: VAR_NAME ASSIGNMENT funcCall;

arithmeticOperator:
    '+'
    | '-'
    | '*'
    | '/'
    | '%'
    | '^';

relationalOperator:
    '>'
    | '<'
    | '<='
    | '>='
    | '='
    | '<>';

logicalOperator:
    AND
    | OR
    | DENY;

// IF STATEMENT RULE
ifStatement:
    IF OPEN_PARENTHESIS? (VAR_NAME | (INT | FLOAT | STRING | BOOL)) (relationalOperator | logicalOperator) (VAR_NAME | (INT | FLOAT | STRING | BOOL)) CLOSE_PARENTHESIS? THEN
    WS* expressions* WS*
    (ELSE expressions* WS*)*
    END_IF;

// WHILE STATEMENT RULE
whileStatement:
    WHILE OPEN_PARENTHESIS? (VAR_NAME | (INT | FLOAT | STRING | BOOL)) relationalOperator (VAR_NAME | (INT | FLOAT | STRING | BOOL)) CLOSE_PARENTHESIS? DO
    WS* expressions* WS*
    END_WHILE;

// FUNC DECLARATIONS RULES
funcInt:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? funcVarDeclaration*? CLOSE_PARENTHESIS? COLON TYPE_INT
    declarations*?
    BEGIN
        (expressions)*
        (RETURN (INT | VAR_NAME))
    END_FUNC;

funcFloat:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? funcVarDeclaration*? CLOSE_PARENTHESIS? COLON TYPE_FLOAT
    declarations*?
    BEGIN
        (expressions)*
        (RETURN (FLOAT | VAR_NAME)) WS*
    END_FUNC;

funcBool:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? funcVarDeclaration*? CLOSE_PARENTHESIS? COLON TYPE_BOOL
    declarations*?
    BEGIN
        (expressions)*
        (RETURN (BOOL | VAR_NAME)) WS*
    END_FUNC;

funcString:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? funcVarDeclaration*? CLOSE_PARENTHESIS? COLON TYPE_STRING
    declarations*?
    BEGIN
        (expressions)*
        (RETURN (STRING | VAR_NAME)) WS*
    END_FUNC;

funcVoid:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? funcVarDeclaration*? CLOSE_PARENTHESIS? COLON TYPE_VOID
    declarations*?
    BEGIN
        (expressions)*
        (RETURN) WS*
    END_FUNC;

funcCall:
    VAR_NAME
    OPEN_PARENTHESIS
        (
            (VAR_NAME | ( INT | FLOAT | BOOL | STRING))+ |
            (COMMA (VAR_NAME | (INT | FLOAT | BOOL | STRING)))
        )+
    CLOSE_PARENTHESIS;

/* LEXER RULES */
/* FRAGMENTS */
fragment DIGIT: [0-9];
fragment A : [aA];
fragment B : [bB];
fragment C : [cC];
fragment D : [dD];
fragment E : [eE];
fragment F : [fF];
fragment G : [gG];
fragment H : [hH];
fragment I : [iI];
fragment J : [jJ];
fragment K : [kK];
fragment L : [lL];
fragment M : [mM];
fragment N : [nN];
fragment O : [oO];
fragment P : [pP];
fragment Q : [qQ];
fragment R : [rR];
fragment S : [sS];
fragment T : [tT];
fragment U : [uU];
fragment V : [vV];
fragment W : [wW];
fragment X : [xX];
fragment Y : [yY];
fragment Z : [zZ];

/* IDS */
PROGRAM: A L G O R I T M O;
BEGIN: I N I C I O;
END: F I M A L G O R I T M O;

VAR: V A R;
PRINT: E S C R E V A;
READ: L E I A;

IF: S E;
THEN: E N T A O;
ELSE: S E N A O;
END_IF: F I M S E;

WHILE: E N Q U A N T O;
DO: F A C A;
END_WHILE: F I M E N Q U A N T O;

BREAK: B R E A K;
CONTINUE: C O N T I N U E;

OPEN_PARENTHESIS: '(';
CLOSE_PARENTHESIS: ')';

COMMA: ',';
SEMI_COLON: ';';
COLON: ':';

ASSIGNMENT: '<-';

DENY: N A O;
MOD: M O D;

FUNC: F U N C A O;
END_FUNC: F I M F U N C A O;
RETURN: R E T O R N E;

TYPE_STRING: C A R A C T E R E;
TYPE_INT: I N T E I R O;
TYPE_FLOAT: R E A L;
TYPE_BOOL: L O G I C O;
TYPE_VOID: V O I D;

STRING: ["][a-zA-Z0-9 $&+,:;=?@#|'<>.^*()_\\"%-]+["];
INT: [-]? DIGIT+;
FLOAT: [-]? DIGIT+ ([.]DIGIT+)?;
BOOL: 'VERDADEIRO' | 'FALSO';

VAR_NAME: [a-zA-Z]+[a-zA-Z0-9_]*;
COMMENT: '//'.*?[\n] -> skip;
WS: [ \t\u000C\n\r] -> skip;
