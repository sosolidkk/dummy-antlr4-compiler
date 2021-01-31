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

/* PARSER RULES */

programName:
    PROGRAM STRING WS*;

declarations:
    uniqueLineVar;


funcDeclarations:
    funcInt
    | funcBool
    | funcFloat
    | funcString
    | funcVoid;

expressions:
    printer
    | reader
    | constOperations
    | constNumeric
    | constString
    | constBool
    | ifStatement
    | whileStatement
    | funcCall;

comment_line: WS* COMMENT+;

printer: printSingleValue | printMultipleValues;
printSingleValue:
    PRINT WS* OPEN_PARENTHESIS (STRING | INT | FLOAT | BOOL) CLOSE_PARENTHESIS WS*;
printMultipleValues:
    PRINT OPEN_PARENTHESIS ((STRING | VAR_NAME) (COMMA (STRING | VAR_NAME))*)+ CLOSE_PARENTHESIS;

reader: readSingleValue;
readSingleValue: READ WS* OPEN_PARENTHESIS (VAR_NAME) CLOSE_PARENTHESIS WS*;
//readMultipleValues: ;

varString:
    VAR VAR_NAME (COMMA VAR_NAME)* COLON WS* TYPE_STRING WS*;
varInt:
    VAR VAR_NAME (COMMA VAR_NAME)* COLON WS* TYPE_INT WS*;
varFloat:
    VAR VAR_NAME (COMMA VAR_NAME)* COLON WS* TYPE_FLOAT WS*;
varBool:
    VAR VAR_NAME (COMMA VAR_NAME)* COLON WS* TYPE_BOOL WS*;

uniqueLineVar:
    VAR 
        (VAR_NAME (COMMA VAR_NAME)* COLON WS* 
            (TYPE_STRING | TYPE_INT | TYPE_FLOAT | TYPE_BOOL) 
    *)+;

uniqueLineMultiDeclarations: VAR (uniqueLineDeclaration COLON TYPES)*;
uniqueLineDeclaration: VAR_NAME | (VAR_NAME COMMA TYPES)*;

// STILL MISSING OPERATION WITH + SYMBOL
constNumeric: VAR_NAME ASSIGNMENT (INT | FLOAT) WS*;
constString: VAR_NAME ASSIGNMENT STRING WS*;
constBool: VAR_NAME ASSIGNMENT BOOL WS*;
constOperations: VAR_NAME ASSIGNMENT VAR_NAME ((arithmeticOperator | binaryOperator) (VAR_NAME | (INT | FLOAT)))*;

arithmeticOperator:
    '+'
    | '-'
    | '*'
    | '/'
    | '%'
    | '^';

binaryOperator:
    '>'
    | '<'
    | '<='
    | '>='
    | '=='
    | '!='
    | '&&'
    | '||';

preUnaryOperator: ('!' | '-');
posUnaryOperator: ('++' | '--');

operation: (preUnaryOperator | posUnaryOperator)? innerOperation binaryOperator arithmeticOperator;
innerOperation: (VAR_NAME | OPEN_PARENTHESIS operation CLOSE_PARENTHESIS);

condition:
    BOOL
    | INT
    | FLOAT
    | STRING
    | innerCodition
    | condition binaryOperator condition
    | (preUnaryOperator | posUnaryOperator) condition
    | condition posUnaryOperator
    | funcCall;

innerCodition: VAR_NAME | OPEN_PARENTHESIS condition CLOSE_PARENTHESIS;

ifStatement:
    WS* IF OPEN_PARENTHESIS? condition CLOSE_PARENTHESIS? THEN
    WS* expressions* WS*
    (ELSE expressions* WS*)*
    END_IF;

whileStatement:
    WS* WHILE OPEN_PARENTHESIS? condition CLOSE_PARENTHESIS? DO
    WS* expressions* WS*
    END_WHILE;

funcInt:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? declarations*? CLOSE_PARENTHESIS? COLON TYPE_INT
    declarations*?
    BEGIN
        WS* (expressions)* WS*
        WS* (RETURN condition) WS*
    END_FUNC;

funcFloat:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? declarations*? CLOSE_PARENTHESIS? COLON TYPE_FLOAT
    declarations*?
    BEGIN
        WS* (expressions)* WS*
        WS* (RETURN condition) WS*
    END_FUNC;

funcBool:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? declarations*? CLOSE_PARENTHESIS? COLON TYPE_BOOL
    declarations*?
    BEGIN
        WS* (expressions)* WS*
        WS* (RETURN condition) WS*
    END_FUNC;

funcString:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? declarations*? CLOSE_PARENTHESIS? COLON TYPE_STRING
    declarations*?
    BEGIN
        WS* (expressions)* WS*
        WS* (RETURN condition) WS*
    END_FUNC;

funcVoid:
    FUNC VAR_NAME WS* OPEN_PARENTHESIS? declarations*? CLOSE_PARENTHESIS? COLON TYPE_VOID
    declarations*?
    BEGIN
        WS* (expressions)* WS*
        WS* (RETURN) WS*
    END_FUNC;

funcCall:
    VAR_NAME OPEN_PARENTHESIS (condition (COMMA condition)*)? CLOSE_PARENTHESIS;

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
TYPES: ('caractere' | 'inteiro' | 'real' | 'logico');

STRING: ["][a-zA-Z0-9 $&+,:;=?@#|'<>.^*()_%-]+ ["];
INT: [-]? DIGIT+;
FLOAT: [-]? DIGIT+ ([.]DIGIT+)?;
BOOL: 'VERDADEIRO' | 'FALSO';

VAR_NAME: [a-zA-Z]+[a-zA-Z0-9_]*;
COMMENT: '//' (.)*? -> skip;
WS: [ \t\u000C\n\r] -> skip;
