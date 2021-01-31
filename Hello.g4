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
    PRINT WS* OPEN_PARENTHESIS (STRING | INT | FLOAT | BOOL) CLOSE_PARENTHESIS WS*;
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
    IF OPEN_PARENTHESIS? (VAR_NAME | (TYPE_INT | TYPE_FLOAT | TYPE_STRING | TYPE_BOOL)) (relationalOperator | logicalOperator) (VAR_NAME | (TYPE_INT | TYPE_FLOAT | TYPE_STRING | TYPE_BOOL)) CLOSE_PARENTHESIS? THEN
    WS* expressions* WS*
    (ELSE expressions* WS*)*
    END_IF;

// WHILE STATEMENT RULE
whileStatement:
    WHILE OPEN_PARENTHESIS? (VAR_NAME | (TYPE_INT | TYPE_FLOAT | TYPE_STRING | TYPE_BOOL)) relationalOperator (VAR_NAME | (TYPE_INT | TYPE_FLOAT | TYPE_STRING | TYPE_BOOL)) CLOSE_PARENTHESIS? DO
    WS* expressions* WS*
    END_WHILE;

// FUNC DECLARATIONS RULES
funcInt:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? funcVarDeclaration*? CLOSE_PARENTHESIS? COLON TYPE_INT
    declarations*?
    BEGIN
        (expressions)*
        (RETURN (TYPE_INT | VAR_NAME))
    END_FUNC;

funcFloat:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? funcVarDeclaration*? CLOSE_PARENTHESIS? COLON TYPE_FLOAT
    declarations*?
    BEGIN
        (expressions)*
        (RETURN (TYPE_FLOAT | VAR_NAME)) WS*
    END_FUNC;

funcBool:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? funcVarDeclaration*? CLOSE_PARENTHESIS? COLON TYPE_BOOL
    declarations*?
    BEGIN
        (expressions)*
        (RETURN (TYPE_BOOL | VAR_NAME)) WS*
    END_FUNC;

funcString:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? funcVarDeclaration*? CLOSE_PARENTHESIS? COLON TYPE_STRING
    declarations*?
    BEGIN
        (expressions)*
        (RETURN (TYPE_STRING | VAR_NAME)) WS*
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
        (VAR_NAME | 
            (
                VAR_NAME | (TYPE_INT | TYPE_FLOAT | TYPE_STRING | TYPE_BOOL) 
                    (relationalOperator | logicalOperator) 
                (VAR_NAME | (TYPE_INT | TYPE_FLOAT | TYPE_STRING | TYPE_BOOL))
            )*
        ) 
    CLOSE_PARENTHESIS;

/* LEXER RULES */
/* FRAGMENTS */
fragment DIGIT: [0-9];

/* IDS */
PROGRAM: 'algoritmo';
BEGIN: 'inicio';
END: 'fimalgoritmo';

VAR: 'var';
PRINT: 'escreva';
READ: 'leia';

IF: 'se';
THEN: 'entao';
ELSE: 'senao';
END_IF: 'fimse';

WHILE: 'enquanto';
DO: 'faca';
END_WHILE: 'fimenquanto';

BREAK: 'break';
CONTINUE: 'continue';

OPEN_PARENTHESIS: '(';
CLOSE_PARENTHESIS: ')';

COMMA: ',';
SEMI_COLON: ';';
COLON: ':';

ASSIGNMENT: '<-';
OR: 'ou';
AND: 'e';
DENY: 'nao';
MOD: 'MOD';

FUNC: 'funcao';
END_FUNC: 'fimfuncao';
RETURN: 'retorne';

TYPE_STRING: 'caractere';
TYPE_INT: 'inteiro';
TYPE_FLOAT: 'real';
TYPE_BOOL: 'logico';
TYPE_VOID: 'void';

STRING: ["][a-zA-Z0-9 $&+,:;=?@#|'<>.^*()_%-]+ ["];
INT: [-]? DIGIT+;
FLOAT: [-]? DIGIT+ ([.]DIGIT+)?;
BOOL: 'VERDADEIRO' | 'FALSO';

VAR_NAME: [a-zA-Z]+[a-zA-Z0-9_]*;
COMMENT: '//'.*?[\n] -> skip;
WS: [ \t\u000C\n\r] -> skip;
