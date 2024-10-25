
module c3lox::parser;
import std::collections::list, c3lox::lexer;

struct Exprs {
  ExprNodeList nodes;
  ExprValues values;
}

// Index of an expressions in an ExprNodeList
def ExprIndex = usz;

def ExprNodeList = List(<ExprNode>);
struct ExprNode {
  typeid type;
  usz value_i;
}

struct ExprValues {
  BinaryExprList binary;
  GroupingExprList grouping;
  LiteralExprList literal;
  UnaryExprList unary;
}

def BinaryExprList = List(<BinaryExpr>);
struct BinaryExpr {
  ExprIndex left_expr_i;
  ExprIndex right_expr_i;
  TokenIndex operator_i;
}

def GroupingExprList = List(<GroupingExpr>);
struct GroupingExpr {
  ExprIndex inner_expr_i;
}

def UnaryExprList = List(<UnaryExpr>);
struct UnaryExpr {
  TokenIndex operator_i;
  ExprIndex right_expr_i;
}

def LiteralExprList = List(<LiteralExpr>);
struct LiteralExpr {
  TokenIndex literal_i;
}


