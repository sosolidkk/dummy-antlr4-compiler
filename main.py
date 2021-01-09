import sys

from antlr4 import CommonTokenStream, FileStream, ParseTreeWalker, Token

from HelloLexer import HelloLexer
from HelloListener import HelloListener
from HelloParser import HelloParser


class HelloPrintListener(HelloListener):
    def foo():
        pass


if __name__ == "__main__":
    input_data = FileStream(sys.argv[1])

    lexer = HelloLexer(input_data)
    stream = CommonTokenStream(lexer)
    stream.fill()

    for token in stream.tokens:
        if token.type != Token.EOF:
            token_attr = None
            token_type = token.type
            token_line = token.line
            token_text = token.text

            if token_type == lexer.ASSIGNMENT:
                token_attr = "ASSIGNMENT"
            if token_type == lexer.BEGIN:
                token_attr = "BEGIN"
            if token_type == lexer.BOOL:
                token_attr = "BOOL"
            if token_type == lexer.BREAK_LINE:
                token_attr = "BREAK_LINE"
            if token_type == lexer.CLOSE_PARENTHESIS:
                token_attr = "CLOSE_PARENTHESIS"
            if token_type == lexer.COLON:
                token_attr = "COLON"
            if token_type == lexer.COMMA:
                token_attr = "COMMA"
            if token_type == lexer.COMMENT:
                token_attr = "COMMENT"
            if token_type == lexer.CONTINUE:
                token_attr = "CONTINUE"
            if token_type == lexer.DENY:
                token_attr = "DENY"
            if token_type == lexer.DO:
                token_attr = "DO"
            if token_type == lexer.ELSE:
                token_attr = "ELSE"
            if token_type == lexer.END:
                token_attr = "END"
            if token_type == lexer.END_IF:
                token_attr = "END_IF"
            if token_type == lexer.END_WHILE:
                token_attr = "END_WHILE"
            if token_type == lexer.FLOAT:
                token_attr = "FLOAT"
            if token_type == lexer.IF:
                token_attr = "IF"
            if token_type == lexer.INT:
                token_attr = "INT"
            if token_type == lexer.MOD:
                token_attr = "MOD"
            if token_type == lexer.OPEN_PARENTHESIS:
                token_attr = "OPEN_PARENTHESIS"
            if token_type == lexer.PRINT:
                token_attr = "PRINT"
            if token_type == lexer.PROGRAM:
                token_attr = "PROGRAM"
            if token_type == lexer.READ:
                token_attr = "READ"
            if token_type == lexer.SEMI_COLON:
                token_attr = "SEMI_COLON"
            if token_type == lexer.STRING:
                token_attr = "STRING"
            if token_type == lexer.TYPE_BOOL:
                token_attr = "TYPE_BOOL"
            if token_type == lexer.TYPE_FLOAT:
                token_attr = "TYPE_FLOAT"
            if token_type == lexer.TYPE_INT:
                token_attr = "TYPE_INT"
            if token_type == lexer.TYPE_STRING:
                token_attr = "TYPE_STRING"
            if token_type == lexer.VAR:
                token_attr = "VAR"
            if token_type == lexer.VAR_NAME:
                token_attr = "VAR_NAME"
            if token_type == lexer.WHILE:
                token_attr = "WHILE"
            if token_type == lexer.FUNC:
                token_attr = "FUNC"
            if token_type == lexer.END_FUNC:
                token_attr = "END_FUNC"
            if token_type == lexer.RETURN:
                token_attr = "RETURN"

            if token_attr is not None:
                print(f"{token_line} {token_attr}[{token_type}] {token.text}")
            else:
                print(f"{token_line} None[{token_type}] {token.text}")
