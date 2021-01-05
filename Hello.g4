grammar Hello;
prog:   (
            COMMENT* 
            programName
            COMMENT*
            declarations*
            COMMENT*
            BEGIN
            COMMENT*
            expressions*
            COMMENT*
            END
            COMMENT*
        )*  EOF;

/* PARSER RULES */

programName:
    PROGRAM STRING WS*;

declarations:
    varString
    | varInt
    | varFloat
    | varBool;

expressions:
    printer
    | reader
    | constNumeric
    | constString
    | constBool
    | ifStatement
    | whileStatement;

comment_line: WS* COMMENT*;

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

// STILL MISSING OPERATION WITH + SYMBOL
constNumeric: VAR_NAME ASSIGNMENT (INT | FLOAT) WS*;
constString: VAR_NAME ASSIGNMENT STRING WS*;
constBool: VAR_NAME ASSIGNMENT BOOL WS*;

binaryOperator:
    '+'
    | '-'
    | '*'
    | '/'
    | '%'
    | '>'
    | '<'
    | '<='
    | '>='
    | '=='
    | '!='
    | '&&'
    | '||';

preUnaryOperator: ('!' | '-');
posUnaryOperator: ('++' | '--');
exponentialOperator: '^';

operation: (preUnaryOperator | posUnaryOperator)? innerOperation posUnaryOperator exponentialOperator binaryOperator;
innerOperation: (VAR_NAME | OPEN_PARENTHESIS operation CLOSE_PARENTHESIS);

condition: 
    BOOL
    | INT
    | FLOAT
    | STRING
    | innerCodition
    | condition binaryOperator condition
    | (preUnaryOperator | posUnaryOperator) condition
    | condition posUnaryOperator;

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

TYPE_STRING: 'caractere';
TYPE_INT: 'inteiro';
TYPE_FLOAT: 'real';
TYPE_BOOL: 'logico';

STRING: ["][a-zA-Z0-9 $&+,:;=?@#|'<>.^*()_%-]+ ["];
INT: [-]? DIGIT+;
FLOAT: [-]? DIGIT+ ([.]DIGIT+)?;
BOOL: 'VERDADEIRO' | 'FALSO';

VAR_NAME: [a-zA-Z]+ [_a-zA-Z0-9]*;
COMMENT: '//' (.)*? '\n' -> skip;
WS: ('\t' | ' ' | '\r' | '\n'| '\u000C')+ -> skip;
BREAK_LINE: ('\n' | '\r');