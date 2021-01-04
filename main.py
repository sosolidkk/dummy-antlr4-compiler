import sys

from antlr4 import CommonTokenStream, FileStream, ParseTreeWalker

from HelloLexer import HelloLexer
from HelloParser import HelloParser
from HelloListener import HelloListener


class HelloPrintListener(HelloListener):
    def foo():
        pass


if __name__ == "__main__":
    input_data = FileStream(sys.argv[1])

    lexer = HelloLexer(input_data)
    stream = CommonTokenStream(lexer)
    parser = HelloParser(stream)
    tree = parser.prog()
    printer = HelloPrintListener()

    walker = ParseTreeWalker()
    walker.walk(printer, tree)

    stream.fill()

    print([(token.text, token.type) for token in stream.tokens])
