
module c3lox::parser;
import std::collections::list, c3lox::lexer;

struct Exprs {
  ExprNodeList nodes;
  ExprValues values;
}

struct ExprNode {
  typeid type;
  usz value_i;
}

// Index of a node in ExprNodeList
def ExprIndex = usz;
def ExprNodeList = List(<ExprNode>);

