import sys

from antlr4 import CommonTokenStream, FileStream, ParseTreeWalker, Token
from antlr4.tree.Trees import Trees
from antlr4.tree.Tree import TerminalNodeImpl

from HelloLexer import HelloLexer
from HelloListener import HelloListener
from HelloParser import HelloParser

tree_representation = ""


def generate_indented_tree(tree, rule_names, indent=0):
    global tree_representation
    if tree.getText() == "<EOF>":
        return
    elif isinstance(tree, TerminalNodeImpl):
        tree_representation += ("    " * indent) + f"TOKEN='{tree.getText()}'\n"
    else:
        tree_representation += ("    " * indent) + f"{rule_names[tree.getRuleIndex()]}\n"
        for child in tree.children:
            generate_indented_tree(child, rule_names, indent + 1)


if __name__ == "__main__":
    input_data = FileStream(sys.argv[1])
    tokens_print = []

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
                tokens_print.append(f"{token_line} {token_attr}[{token_type}] {token.text}\n")
            else:
                tokens_print.append(f"{token_line} None[{token_type}] {token.text}\n")

    input_stream = FileStream(sys.argv[1], encoding="utf8")
    lexer = HelloLexer(input=input_stream)
    tokens = CommonTokenStream(lexer=lexer)
    parser = HelloParser(tokens)
    printer = HelloListener()
    walker = ParseTreeWalker()

    tree = parser.prog()
    generate_indented_tree(tree, parser.ruleNames)

    with open("tree_example.txt", "w") as file:
        file.write("-- GENERATED TOKENS BEGIN --\n")
        file.writelines(tokens_print)
        file.write("-- GENERATED TOKENS END --\n")

        file.write("\n-- GENERATED TREE INDENT BEGIN --\n")
        file.write(tree_representation)
        file.write("-- GENERATED TREE INDENT END --\n")

        file.write("\n-- GENERATED TREE BEGIN --\n")
        file.write(str(Trees.toStringTree(tree, None, parser)))
        file.write("\n-- GENERATED TREE END --\n")
