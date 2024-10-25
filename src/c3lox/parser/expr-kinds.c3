
module c3lox::parser;
import std::collections::list, c3lox::lexer;

struct BinaryExpr {
  ExprIndex left_expr_i;
  ExprIndex right_expr_i;
  TokenIndex operator_i;
}

struct GroupingExpr {
  ExprIndex inner_expr_i;
}

struct UnaryExpr {
  TokenIndex operator_i;
  ExprIndex right_expr_i;
}

struct LiteralExpr {
  TokenIndex literal_i;
}

def LiteralExprList = List(<LiteralExpr>);
def GroupingExprList = List(<GroupingExpr>);
def UnaryExprList = List(<UnaryExpr>);
def BinaryExprList = List(<BinaryExpr>);

